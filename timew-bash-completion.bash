# bash-completion for timewarrior
# https://taskwarrior.org/docs/timewarrior/
# put this file in /etc/bash_completion.d/


_timew_commands()
{
    timew help | sed -e '/^Usage:/d'  -e '/^Additional help:/Q' \
        -e 's/timew \[*\([a-z]\+\)\]*.*/\1/g;tx;d;:x'
}


_timew_tags()
{
#    timew tags|tail -n+4|cut -d'-' -f1
    timew tags | tail -n+4 | head -n-1 | grep -P '^.*[^\s](?=\s+-\s*)' -o
}


_timew_ids()
{
    timew summary :ids | sed -e 's/.*@\([0-9]\+\).*/@\1/g;tx;d;:x'
}


_timew_reports()
{
    timew extensions | sed -e 's/^\(.*\).*Active/\1/g;tx;d;:x'
}


__timew()
{
    local cur cmd opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    cmd="${COMP_WORDS[1]}"
        
    # assuming command is first parameter (as in help text) followed by
    # options (tags, interval etc.) even if a different order is allowed too

    # TODO it would be nice if 'timew s [tab]' gives suggestions to for
    # summary, but this does not work ATM

    local IFS=$'\n'

    if [ $COMP_CWORD -eq 1 ]; then
        opts="$(_timew_commands) $(_timew_reports) --version"
    else
        case "$cmd" in
            start | stop | export | gaps | summary | tags | track | day | week | month)
                # no suggestion for <date>, this would be meaningless
                 #opts="$(_timew_tags)"
                 opts=$(timew tags 3days | \
    tail -n+4 | \
    head -n-1 | \
    grep -P '^.*[^\s](?=\s+-\s*)' -o | \
    sort
)
                ;;
            tag | untag)
                opts="$(_timew_ids)"
                if [ $COMP_CWORD -gt 2 ]; then
                    opts="$opts $(_timew_tags)"
                fi
                ;;
            delete | split | shorten | lengthen)
                opts="$(_timew_ids)"
                ;;
            join)
                # TODO check if subsequent?
                if [ $COMP_CWORD -lt 4 ]; then
                    opts="$(_timew_ids)"
                fi
                ;;
            move)
                if [ $COMP_CWORD -lt 3 ]; then
                    opts="$(_timew_ids)"
                fi
                ;;
            report)
                opts="$(_timew_reports)"
                ;;
            get)
                # TODO get <DOM> [<DOM> ...]
                ;;
            help)
                opts="$(_timew_commands) interval hints date duration"
                ;;
        esac

    fi
    
    CANDIDATES=( $(compgen -W "${opts}" -- ${cur}) )

    # Correctly set our candidates to COMPREPLY
    if [ ${#CANDIDATES[*]} -eq 0 ]; then
        COMPREPLY=()
    else
        COMPREPLY=($(printf '%q\n' "${CANDIDATES[@]}"))
    fi
}

complete -F __timew timew


_snapper()
{
    local configdir="/etc/snapper/configs"
    local cur prev words cword
    _init_completion || return

    local GLOGAL_SNAPPER_OPTIONS='
        -q --quiet
        -v --verbose
        --utc
        --iso
        -t --table-style
        -c --config
        -r --root
        --no-dbus
        --version
        --help
    '

    # see if the user selected a command already
    local COMMANDS=(
        "list-configs" "create-config" "delete-config" "set-config"
        "list" "ls"
        "create" "modify" "delete" "remove" "rm"
        "mount" "umount"
        "status" "diff" "xadiff"
        "undochange" "rollback"
        "setup-quota"
        "cleanup")

    local command i
    for (( i=0; i < ${#words[@]}-1; i++ )); do
        if [[ ${COMMANDS[@]} =~ ${words[i]} ]]; then
            command=${words[i]}
            break
        fi
    done

    case $prev in
        --version|--help)
            return 0
            ;;
    esac

    # supported options per command
    if [[ "$cur" == -* ]]; then
        case $command in
            create-config)
                COMPREPLY=( $( compgen -W '--fstype -f
                  --templete -t' -- "$cur" ) )
                return 0
                ;;
            list|ls)
                COMPREPLY=( $( compgen -W '--type -t
                  --all-configs -a' -- "$cur" ) )
                return 0
                ;;
            create)
                COMPREPLY=( $( compgen -W '--type -t
                  --pre-number
                  --print-number -p
                  --description -d
                  --cleanup-algorithm -c
                  --userdata -u
                  --command' -- "$cur" ) )
                return 0
                ;;
            modify)
                COMPREPLY=( $( compgen -W '--description -d
                  --cleanup-algorithm -c
                  --userdata -u' -- "$cur" ) )
                return 0
                ;;
            delete|remove|rm)
                COMPREPLY=( $( compgen -W '--sync -s
                  ' -- "$cur" ) )
                return 0
                ;;
            status)
                COMPREPLY=( $( compgen -W '--output -o
                    ' -- "$cur" ) )
                return 0
                ;;
            diff)
                COMPREPLY=( $( compgen -W '--input -i
                    --diff-cmd
                    --extensions -x' -- "$cur" ) )
                return 0
                ;;
            undochange)
                COMPREPLY=( $( compgen -W '--input -i
                    ' -- "$cur" ) )
                return 0
                ;;
            rollback)
                COMPREPLY=( $( compgen -W '--print-number -p
                    --description -d
                    --cleanup-algorithm -c
                    --userdata -u' -- "$cur" ) )
                return 0
                ;;
            *)
                COMPREPLY=( $( compgen -W "$GLOGAL_SNAPPER_OPTIONS" -- "$cur" ) )
                return 0
                ;;
        esac
    fi

    # specific command arguments
    if [[ -n $command ]]; then
        case $command in
            create-config)
                case "$prev" in
                     --fstype|-f)
                        COMPREPLY=( $( compgen -W 'btrfs ext4 lvm(xfs) lvm(ext4)
                        ' -- "$cur" ) )
                        ;;
                esac
                return 0
                ;;
            list)
                case "$prev" in
                    --type|-t)
                        COMPREPLY=( $( compgen -W 'all single pre-post
                        ' -- "$cur" ) )
                        ;;
                esac
                return 0
                ;;
            create)
                case "$prev" in
                    --type|-t)
                        COMPREPLY=( $( compgen -W 'single pre post
                        ' -- "$cur" ) )
                        ;;
                    --pre-number)
                        COMPREPLY=( $( compgen -W '
                        ' -- "$cur" ) )
                        ;;
                    --cleanup-algorithm|-c)
                        COMPREPLY=( $( compgen -W 'empty-pre-post timeline number
                        ' -- "$cur" ) )
                        ;;
                esac
                return 0
                ;;
            modify)
                case "$prev" in
                    --cleanup-algorithm|-c)
                        COMPREPLY=( $( compgen -W 'empty-pre-post timeline number
                        ' -- "$cur" ) )
                        ;;
                esac
                return 0
                ;;
            status)
                case "$prev" in
                    --output|-o)
                        COMPREPLY=( $( compgen -f -- "$cur" ) )
                        ;;
                esac
                return 0
                ;;
            cleanup)
                case "$prev" in
                    empty-pre-post|timeline|number)
                    ;;
                    *)
                    COMPREPLY=( $( compgen -W 'empty-pre-post timeline number
                    ' -- "$cur" ) )
                    ;;
                esac
                return 0
                ;;
            diff)
                return 0
                ;;
            undochange)
                return 0
                ;;
            rollback)
                case "$prev" in
                    --cleanup-algorithm|-c)
                        COMPREPLY=( $( compgen -W 'empty-pre-post timeline number
                        ' -- "$cur" ) )
                        ;;
                esac
                return 0
                ;;
        esac
    fi

    # no command yet, show what commands we have
    if [ "$command" = "" ]; then
        COMPREPLY=( $( compgen -W '${COMMANDS[@]} ${GLOGAL_SNAPPER_OPTIONS[@]}' -- "$cur" ) )
    fi

    return 0
} &&
complete -F _snapper snapper

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# All consumers are gone.
# Bug #156882, #574642, #637740.  Removal in 14 days.

# Variables to specify in an ebuild which uses this eclass:
# GAME - (doom3, quake4 or ut2004, etc), unless ${PN} starts with e.g. "doom3-"
# MOD_DESC - Description for the mod
# MOD_NAME - Creates a command-line wrapper and desktop icon for the mod
# MOD_DIR - Subdirectory name for the mod, if applicable
# MOD_ICON - Custom icon for the mod, instead of the default

inherit eutils games

EXPORT_FUNCTIONS src_install pkg_postinst

[[ -z ${GAME} ]] && GAME=${PN%%-*}

case ${GAME} in
	doom3)
		GAME_PKGS="games-fps/doom3"
		GAME_DIRS=( "${GAMES_PREFIX_OPT}"/doom3 )
		GAME_NAME="Doom 3"
		GAME_BIN="doom3"
		GAME_ICON="doom3"
		DED_PKGS=""
		DED_BIN="doom3-ded"
		DED_OPTS="+set dedicated 1 +exec server.cfg"
		DED_CFG_DIR=".doom3"
		SELECT_MOD="+set fs_game "
		;;
	enemy-territory)
		GAME_PKGS="games-fps/enemy-territory"
		GAME_DIRS=( "${GAMES_PREFIX_OPT}"/enemy-territory )
		GAME_NAME="Enemy Territory"
		GAME_BIN="et"
		GAME_ICON="ET"
		DED_PKGS=""
		DED_BIN="et-ded"
		DED_OPTS="+set dedicated 1 +exec server.cfg"
		DED_CFG_DIR=".etwolf"
		SELECT_MOD="+set fs_game "
		;;
	quake3)
		GAME_PKGS="games-fps/quake3 games-fps/quake3-bin"
		GAME_DIRS=( "${GAMES_DATADIR}"/quake3 "${GAMES_PREFIX_OPT}"/quake3 )
		GAME_NAME="Quake III"
		GAME_BIN="quake3"
		GAME_ICON="quake3"
		DED_PKGS=""
		DED_BIN="quake3-ded"
		DED_OPTS="+set dedicated 1 +exec server.cfg"
		DED_CFG_DIR=".q3a"
		SELECT_MOD="+set fs_game "
		;;
	quake4)
		GAME_PKGS="games-fps/quake4-bin"
		GAME_DIRS=( "${GAMES_PREFIX_OPT}"/quake4 )
		GAME_NAME="Quake 4"
		GAME_BIN="quake4"
		GAME_ICON="/usr/share/pixmaps/quake4.bmp"
		DED_PKGS=""
		DED_BIN="quake4-ded"
		DED_OPTS="+set dedicated 1 +exec server.cfg"
		DED_CFG_DIR=".quake4"
		SELECT_MOD="+set fs_game "
		;;
	ut2003)
		GAME_PKGS="games-fps/ut2003"
		GAME_DIRS=( "${GAMES_PREFIX_OPT}"/ut2003 )
		GAME_NAME="UT2003"
		GAME_BIN="ut2003"
		GAME_ICON="ut2003"
		DED_PKGS=""
		DED_BIN="ucc"
		DED_OPTS=""
		DED_CFG_DIR=""
		SELECT_MOD="-mod="
		;;
	ut2004)
		GAME_PKGS="games-fps/ut2004"
		GAME_DIRS=( "${GAMES_PREFIX_OPT}"/{ut2004,ut2004-ded} )
		GAME_NAME="UT2004"
		GAME_BIN="ut2004"
		GAME_ICON="ut2004"
		DED_PKGS="games-server/ut2004-ded"
		DED_BIN="ut2004-ded"
		DED_OPTS=""
		DED_CFG_DIR=""
		SELECT_MOD="-mod="
		;;
	*)
		eerror "This game is either not supported or you must set the GAME"
		eerror "variable to the proper game."
		die "games-mods.eclass: unsupported GAME"
		;;
esac

MOD_BIN="${GAME_BIN}-${PN/${GAME}-}"
MOD_DED_BIN="${MOD_BIN}-ded"

games-mods_get_rdepend() {
	local pkgs

	if [[ ${1} == "--ded" ]] ; then
		pkgs=( ${DED_PKGS} ${GAME_PKGS} )
	else
		pkgs=( ${GAME_PKGS} )
	fi

	[[ ${#pkgs[@]} -gt 1 ]] && echo -n "|| ( "

	case ${EAPI:-0} in
		0|1) echo -n "${pkgs[@]}" ;;
		[23456])
			local p
			if [[ ${1} == "--ded" ]] ; then
				echo -n "${DED_PKGS}"
				for p in ${GAME_PKGS} ; do
					echo -n " ${p}[dedicated]"
				done
			else
				for p in ${GAME_PKGS} ; do
					echo -n " || ( ${p}[opengl] ${p}[-dedicated] )"
				done
			fi
			;;
		*) die "EAPI ${EAPI} not supported"
	esac

	[[ ${#pkgs[@]} -gt 1 ]] && echo -n " )"
}

DESCRIPTION="${GAME_NAME} ${MOD_NAME} - ${MOD_DESC}"

SLOT="0"
IUSE="dedicated opengl"
RESTRICT="bindist mirror strip"

DEPEND="app-arch/unzip"
RDEPEND="dedicated? ( $(games-mods_get_rdepend --ded) )
	opengl? ( $(games-mods_get_rdepend) )
	!dedicated? ( !opengl? ( $(games-mods_get_rdepend) ) )"

S=${WORKDIR}

INS_DIR=${GAMES_DATADIR}/${GAME}

games-mods_use_opengl() {
	[[ -z ${MOD_DIR} ]] && return 1

	if use opengl || ! use dedicated ; then
		# Use opengl by default
		return 0
	fi

	return 1
}

games-mods_use_dedicated() {
	[[ -z ${MOD_DIR} ]] && return 1

	use dedicated && return 0 || return 1
}

games-mods_dosyms() {
	# We are installing everything for these mods into ${INS_DIR},
	# ${GAMES_DATADIR}/${GAME} in most cases, and symlinking it
	# into ${GAMES_PREFIX_OPT}/${GAME} for each game.  This should
	# allow us to support both binary and source-based games easily.
	local dir
	for dir in "${GAME_DIRS[@]}" ; do
		[[ -z ${dir} || ${INS_DIR} == ${dir} ]] && continue
		pushd "${D}/${INS_DIR}" > /dev/null || die "pushd failed"
		local i
		for i in * ; do
			if [[ -d ${i} ]] ; then
				if [[ ${i} == ${MOD_DIR} ]] ; then
					dosym "${INS_DIR}/${i}" "${dir}/${i}" \
						|| die "dosym ${i} failed"
				else
					local f
					while read f ; do
						dosym "${INS_DIR}/${f}" "${dir}/${f}" \
							|| die "dosym ${f} failed"
					done < <(find "${i}" -type f)
				fi
			elif [[ -f ${i} ]] ; then
				dosym "${INS_DIR}/${i}" "${dir}/${i}" \
					|| die "dosym ${i} failed"
			else
				die "${i} shouldn't be there"
			fi
		done
		popd > /dev/null || die "popd failed"
	done
}

games-mods_make_initd() {
	cat <<EOF > "${T}"/${MOD_DED_BIN}
#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Generated by games-mods.eclass

depend() {
	need net
}

start() {
	ebegin "Starting ${MOD_DED_BIN}"
	start-stop-daemon --start --quiet --background --make-pidfile \\
		--pidfile /var/run/${MOD_DED_BIN}.pid \\
		--chuid \${${MOD_DED_BIN//-/_}_user}:\${${MOD_DED_BIN//-/_}_group} \\
		--env HOME="\${${MOD_DED_BIN//-/_}_home}" \\
		--exec "${GAMES_BINDIR}/${MOD_DED_BIN}" \\
		-- \${${MOD_DED_BIN//-/_}_opts}
	eend \$?
}

stop() {
	ebegin "Stopping ${MOD_DED_BIN}"
	start-stop-daemon --stop \\
		--pidfile /var/run/${MOD_DED_BIN}.pid
	eend \$?
}
EOF

	doinitd "${T}"/${MOD_DED_BIN} || die "doinitd failed"
}

games-mods_make_confd() {
	cat <<-EOF > "${T}"/${MOD_DED_BIN}
	# User and group the server should run as
	${MOD_DED_BIN//-/_}_user="${GAMES_USER_DED}"
	${MOD_DED_BIN//-/_}_group="${GAMES_GROUP}"

	# Directory to use for HOME
	${MOD_DED_BIN//-/_}_home="${GAMES_PREFIX}"

	# Any extra options you want to pass to the dedicated server
	${MOD_DED_BIN//-/_}_opts=""
	EOF

	doconfd "${T}"/${MOD_DED_BIN} || die "doconfd failed"
}

games-mods_src_install() {
	if games-mods_use_opengl ; then
		if [[ -n ${MOD_ICON} ]] ; then
			# Install custom icon
			local ext=${MOD_ICON##*.}
			if [[ -f ${MOD_ICON} ]] ; then
				newicon "${MOD_ICON}" ${PN}.${ext} || die "newicon failed"
			else
				newicon ${MOD_DIR}/"${MOD_ICON}" ${PN}.${ext} \
					|| die "newicon failed"
			fi
			case ${ext} in
				bmp|ico)
					MOD_ICON=/usr/share/pixmaps/${PN}.${ext}
					;;
				*)
					MOD_ICON=${PN}
					;;
			esac
		else
			# Use the game's standard icon
			MOD_ICON=${GAME_ICON}
		fi

		games_make_wrapper ${MOD_BIN} "${GAME_BIN} ${SELECT_MOD}${MOD_DIR}"
		make_desktop_entry ${MOD_BIN} "${GAME_NAME} - ${MOD_NAME}" "${MOD_ICON}"
		# Since only quake3 has both a binary and a source-based install,
		# we only look for quake3 here.
		case ${GAME} in
			quake3)
				if has_version games-fps/quake3-bin ; then
					games_make_wrapper ${GAME_BIN}-bin-${PN/${GAME}-} \
						"${GAME_BIN}-bin ${SELECT_MOD}${MOD_DIR}"
				fi
				make_desktop_entry ${GAME_BIN}-bin-${PN/${GAME}-} \
					"${GAME_NAME} - ${MOD_NAME} (binary)" "${MOD_ICON}"
				;;
		esac
	fi

	# We expect anything not wanted to have been deleted by the ebuild
	insinto "${INS_DIR}"
	doins -r * || die "doins -r failed"
	games-mods_dosyms

	if games-mods_use_dedicated ; then
		if [[ -f ${FILESDIR}/server.cfg ]] ; then
			insinto "${GAMES_SYSCONFDIR}"/${GAME}/${MOD_DIR}
			doins "${FILESDIR}"/server.cfg || die "doins server.cfg failed"
			dosym "${GAMES_SYSCONFDIR}"/${GAME}/${MOD_DIR}/server.cfg \
				"${GAMES_PREFIX}"/${DED_CFG_DIR}/${MOD_DIR}/server.cfg \
				|| die "dosym server.cfg failed"
		fi
		games_make_wrapper ${MOD_DED_BIN} \
			"\"${GAMES_BINDIR}/${DED_BIN}\" ${SELECT_MOD}${MOD_DIR} ${DED_OPTS}"
		games-mods_make_initd
		games-mods_make_confd
	fi

	prepgamesdirs
}

games-mods_pkg_postinst() {
	games_pkg_postinst
	if games-mods_use_opengl ; then
		elog "To play this mod run:"
		elog "  ${MOD_BIN}"
	fi
	if games-mods_use_dedicated ; then
		elog "To launch a dedicated server run:"
		elog "  ${MOD_DED_BIN}"
		elog "To launch the server at startup run:"
		elog "  rc-update add ${MOD_DED_BIN} default"
	fi
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cvs.eclass
# @MAINTAINER:
# vapier@gentoo.org (and anyone who wants to help)
# @SUPPORTED_EAPIS: 4 5 6 7
# @BLURB: This eclass provides generic cvs fetching functions
# @DESCRIPTION:
# This eclass provides the generic cvs fetching functions. To use this from an
# ebuild, set the ECLASS VARIABLES as specified below in your ebuild before
# inheriting. Then either leave the default src_unpack or extend over
# cvs_src_unpack. If you find that you need to call the cvs_* functions
# directly, I'd be interested to hear about it.

if [[ -z ${_CVS_ECLASS} ]]; then
_CVS_ECLASS=1

# TODO:

# Implement more auth types (gserver?, kserver?)

# Support additional remote shells with `ext' authentication (does
# anyone actually need to use it with anything other than SSH?)


# Users shouldn't change these settings!  The ebuild/eclass inheriting
# this eclass will take care of that.  If you want to set the global
# KDE cvs ebuilds' settings, see the comments in kde-source.eclass.

# @ECLASS-VARIABLE: ECVS_CVS_COMPRESS
# @DESCRIPTION:
# Set the default compression level.  Has no effect when ECVS_CVS_COMMAND
# is defined by ebuild/user.
: ${ECVS_CVS_COMPRESS:=-z1}

# @ECLASS-VARIABLE: ECVS_CVS_OPTIONS
# @DESCRIPTION:
# Additional options to the cvs commands.  Has no effect when ECVS_CVS_COMMAND
# is defined by ebuild/user.
: ${ECVS_CVS_OPTIONS:=-q -f}

# @ECLASS-VARIABLE: ECVS_CVS_COMMAND
# @DESCRIPTION:
# CVS command to run
#
# You can set, for example, "cvs -t" for extensive debug information
# on the cvs connection.  The default of "cvs -q -f -z4" means to be
# quiet, to disregard the ~/.cvsrc config file and to use maximum
# compression.
: ${ECVS_CVS_COMMAND:=cvs ${ECVS_CVS_OPTIONS} ${ECVS_CVS_COMPRESS}}

# @ECLASS-VARIABLE: ECVS_UP_OPTS
# @DESCRIPTION:
# CVS options given after the cvs update command. Don't remove "-dP" or things
# won't work.
: ${ECVS_UP_OPTS:=-dP}

# @ECLASS-VARIABLE: ECVS_CO_OPTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# CVS options given after the cvs checkout command.

# @ECLASS-VARIABLE: ECVS_OFFLINE
# @DESCRIPTION:
# Set this variable to a non-empty value to disable the automatic updating of
# a CVS source tree. This is intended to be set outside the cvs source
# tree by users.
: ${ECVS_OFFLINE:=${EVCS_OFFLINE}}

# @ECLASS-VARIABLE: ECVS_LOCAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# If this is set, the CVS module will be fetched non-recursively.
# Refer to the information in the CVS man page regarding the -l
# command option (not the -l global option).

# @ECLASS-VARIABLE: ECVS_LOCALNAME
# @DEFAULT_UNSET
# @DESCRIPTION:
# Local name of checkout directory
#
# This is useful if the module on the server is called something
# common like 'driver' or is nested deep in a tree, and you don't like
# useless empty directories.
#
# WARNING: Set this only from within ebuilds!  If set in your shell or
# some such, things will break because the ebuild won't expect it and
# have e.g. a wrong $S setting.

# @ECLASS-VARIABLE: ECVS_TOP_DIR
# @DESCRIPTION:
# The directory under which CVS modules are checked out.
: ${ECVS_TOP_DIR:="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/cvs-src"}

# @ECLASS-VARIABLE: ECVS_SERVER
# @DESCRIPTION:
# CVS path
#
# The format is "server:/dir", e.g. "anoncvs.kde.org:/home/kde".
# Remove the other parts of the full CVSROOT, which might look like
# ":pserver:anonymous@anoncvs.kde.org:/home/kde"; this is generated
# using other settings also.
#
# Set this to "offline" to disable fetching (i.e. to assume the module
# is already checked out in ECVS_TOP_DIR).
: ${ECVS_SERVER:="offline"}

# @ECLASS-VARIABLE: ECVS_MODULE
# @REQUIRED
# @DESCRIPTION:
# The name of the CVS module to be fetched
#
# This must be set when cvs_src_unpack is called.  This can include
# several directory levels, i.e. "foo/bar/baz"
#[[ -z ${ECVS_MODULE} ]] && die "$ECLASS: error: ECVS_MODULE not set, cannot continue"

# @ECLASS-VARIABLE: ECVS_DATE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The date of the checkout.  See the -D date_spec option in the cvs
# man page for more details.

# @ECLASS-VARIABLE: ECVS_BRANCH
# @DEFAULT_UNSET
# @DESCRIPTION:
# The name of the branch/tag to use
#
# The default is "HEAD".  The following default _will_ reset your
# branch checkout to head if used.
#: ${ECVS_BRANCH:="HEAD"}

# @ECLASS-VARIABLE: ECVS_AUTH
# @DESCRIPTION:
# Authentication method to use
#
# Possible values are "pserver" and "ext".  If `ext' authentication is
# used, the remote shell to use can be specified in CVS_RSH (SSH is
# used by default).  Currently, the only supported remote shell for
# `ext' authentication is SSH.
#
# Armando Di Cianno <fafhrd@gentoo.org> 2004/09/27
# - Added "no" as a server type, which uses no AUTH method, nor
#    does it login
#  e.g.
#   "cvs -danoncvs@savannah.gnu.org:/cvsroot/backbone co System"
#   ( from gnustep-apps/textedit )
: ${ECVS_AUTH:="pserver"}

# @ECLASS-VARIABLE: ECVS_USER
# @DESCRIPTION:
# Username to use for authentication on the remote server.
: ${ECVS_USER:="anonymous"}

# @ECLASS-VARIABLE: ECVS_PASS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Password to use for authentication on the remote server

# @ECLASS-VARIABLE: ECVS_SSH_HOST_KEY
# @DEFAULT_UNSET
# @DESCRIPTION:
# If SSH is used for `ext' authentication, use this variable to
# specify the host key of the remote server.  The format of the value
# should be the same format that is used for the SSH known hosts file.
#
# WARNING: If a SSH host key is not specified using this variable, the
# remote host key will not be verified.

# @ECLASS-VARIABLE: ECVS_CLEAN
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this to get a clean copy when updating (passes the
# -C option to cvs update)

PROPERTIES+=" live"

# add cvs to deps
# ssh is used for ext auth
DEPEND="dev-vcs/cvs"

if [[ ${ECVS_AUTH} == "ext" ]] ; then
	#default to ssh
	[[ -z ${CVS_RSH} ]] && export CVS_RSH="ssh"
	if [[ ${CVS_RSH} != "ssh" ]] ; then
		die "Support for ext auth with clients other than ssh has not been implemented yet"
	fi
	DEPEND+=" net-misc/openssh"
fi

case ${EAPI:-0} in
	4|5|6) ;;
	7) BDEPEND="${DEPEND}"; DEPEND="" ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} is not supported" ;;
esac

# called from cvs_src_unpack
cvs_fetch() {
	# Make these options local variables so that the global values are
	# not affected by modifications in this function.

	local ECVS_COMMAND=${ECVS_COMMAND}
	local ECVS_UP_OPTS=${ECVS_UP_OPTS}
	local ECVS_CO_OPTS=${ECVS_CO_OPTS}

	debug-print-function ${FUNCNAME} "$@"

	# Update variables that are modified by ebuild parameters, which
	# should be effective every time cvs_fetch is called, and not just
	# every time cvs.eclass is inherited

	# Handle parameter for local (non-recursive) fetching

	if [[ -n ${ECVS_LOCAL} ]] ; then
		ECVS_UP_OPTS+=" -l"
		ECVS_CO_OPTS+=" -l"
	fi

	# Handle ECVS_BRANCH option
	#
	# Because CVS auto-switches branches, we just have to pass the
	# correct -rBRANCH option when updating.

	if [[ -n ${ECVS_BRANCH} ]] ; then
		ECVS_UP_OPTS+=" -r${ECVS_BRANCH}"
		ECVS_CO_OPTS+=" -r${ECVS_BRANCH}"
	fi

	# Handle ECVS_LOCALNAME, which specifies the local directory name
	# to use.  Note that the -d command option is not equivalent to
	# the global -d option.

	if [[ ${ECVS_LOCALNAME} != "${ECVS_MODULE}" ]] ; then
		ECVS_CO_OPTS+=" -d ${ECVS_LOCALNAME}"
	fi

	if [[ -n ${ECVS_CLEAN} ]] ; then
		ECVS_UP_OPTS+=" -C"
	fi

	if [[ -n ${ECVS_DATE} ]] ; then
		ECVS_CO_OPTS+=" -D ${ECVS_DATE}"
		ECVS_UP_OPTS+=" -D ${ECVS_DATE}"
	fi

	# Create the top dir if needed

	if [[ ! -d ${ECVS_TOP_DIR} ]] ; then
		# Note that the addwrite statements in this block are only
		# there to allow creating ECVS_TOP_DIR; we allow writing
		# inside it separately.

		# This is because it's simpler than trying to find out the
		# parent path of the directory, which would need to be the
		# real path and not a symlink for things to work (so we can't
		# just remove the last path element in the string)

		debug-print "${FUNCNAME}: checkout mode. creating cvs directory"
		addwrite /foobar
		addwrite /
		mkdir -p "/${ECVS_TOP_DIR}"
		export SANDBOX_WRITE="${SANDBOX_WRITE//:\/foobar:\/}"
	fi

	# In case ECVS_TOP_DIR is a symlink to a dir, get the real path,
	# otherwise addwrite() doesn't work.

	cd -P "${ECVS_TOP_DIR}" >/dev/null
	ECVS_TOP_DIR=$(pwd)

	# Disable the sandbox for this dir
	addwrite "${ECVS_TOP_DIR}"

	# Determine the CVS command mode (checkout or update)
	if [[ ! -d ${ECVS_TOP_DIR}/${ECVS_LOCALNAME}/CVS ]] ; then
		mode=checkout
	else
		mode=update
	fi

	# Our server string (i.e. CVSROOT) without the password so it can
	# be put in Root
	local connection="${ECVS_AUTH}"
	if [[ ${ECVS_AUTH} == "no" ]] ; then
		local server="${ECVS_USER}@${ECVS_SERVER}"
	else
		[[ -n ${ECVS_PROXY} ]] && connection+=";proxy=${ECVS_PROXY}"
		[[ -n ${ECVS_PROXY_PORT} ]] && connection+=";proxyport=${ECVS_PROXY_PORT}"
		local server=":${connection}:${ECVS_USER}@${ECVS_SERVER}"
	fi

	# Switch servers automagically if needed
	if [[ ${mode} == "update" ]] ; then
		cd "/${ECVS_TOP_DIR}/${ECVS_LOCALNAME}"
		local oldserver=$(cat CVS/Root)
		if [[ ${server} != "${oldserver}" ]] ; then
			einfo "Changing the CVS server from ${oldserver} to ${server}:"
			debug-print "${FUNCNAME}: Changing the CVS server from ${oldserver} to ${server}:"

			einfo "Searching for CVS directories ..."
			local cvsdirs=$(find . -iname CVS -print)
			debug-print "${FUNCNAME}: CVS directories found:"
			debug-print "${cvsdirs}"

			einfo "Modifying CVS directories ..."
			local x
			for x in ${cvsdirs} ; do
				debug-print "In ${x}"
				echo "${server}" > "${x}/Root"
			done
		fi
	fi

	# Prepare a cvspass file just for this session, we don't want to
	# mess with ~/.cvspass
	touch "${T}/cvspass"
	export CVS_PASSFILE="${T}/cvspass"

	# The server string with the password in it, for login (only used for pserver)
	cvsroot_pass=":${connection}:${ECVS_USER}:${ECVS_PASS}@${ECVS_SERVER}"

	# Ditto without the password, for checkout/update after login, so
	# that the CVS/Root files don't contain the password in plaintext
	if [[ ${ECVS_AUTH} == "no" ]] ; then
		cvsroot_nopass="${ECVS_USER}@${ECVS_SERVER}"
	else
		cvsroot_nopass=":${connection}:${ECVS_USER}@${ECVS_SERVER}"
	fi

	# Commands to run
	cmdlogin=( ${ECVS_CVS_COMMAND} -d "${cvsroot_pass}" login )
	cmdupdate=( ${ECVS_CVS_COMMAND} -d "${cvsroot_nopass}" update ${ECVS_UP_OPTS} ${ECVS_LOCALNAME} )
	cmdcheckout=( ${ECVS_CVS_COMMAND} -d "${cvsroot_nopass}" checkout ${ECVS_CO_OPTS} ${ECVS_MODULE} )

	# Execute commands

	cd "${ECVS_TOP_DIR}"
	if [[ ${ECVS_AUTH} == "pserver" ]] ; then
		einfo "Running ${cmdlogin[*]}"
		"${cmdlogin[@]}" || die "cvs login command failed"
		if [[ ${mode} == "update" ]] ; then
			einfo "Running ${cmdupdate[*]}"
			"${cmdupdate[@]}" || die "cvs update command failed"
		elif [[ ${mode} == "checkout" ]] ; then
			einfo "Running ${cmdcheckout[*]}"
			"${cmdcheckout[@]}" || die "cvs checkout command failed"
		fi
	elif [[ ${ECVS_AUTH} == "ext" || ${ECVS_AUTH} == "no" ]] ; then
		# Hack to support SSH password authentication

		# Backup environment variable values
		local CVS_ECLASS_ORIG_CVS_RSH="${CVS_RSH}"

		if [[ ${SSH_ASKPASS+set} == "set" ]] ; then
			local CVS_ECLASS_ORIG_SSH_ASKPASS="${SSH_ASKPASS}"
		else
			unset CVS_ECLASS_ORIG_SSH_ASKPASS
		fi

		if [[ ${DISPLAY+set} == "set" ]] ; then
			local CVS_ECLASS_ORIG_DISPLAY="${DISPLAY}"
		else
			unset CVS_ECLASS_ORIG_DISPLAY
		fi

		if [[ ${CVS_RSH} == "ssh" ]] ; then
			# Force SSH to use SSH_ASKPASS by creating python wrapper

			export CVS_RSH="${T}/cvs_sshwrapper"
			cat > "${CVS_RSH}"<<EOF
#!${EPREFIX}/usr/bin/python
import fcntl
import os
import sys
try:
	fd = os.open('/dev/tty', 2)
	TIOCNOTTY=0x5422
	try:
		fcntl.ioctl(fd, TIOCNOTTY)
	except:
		pass
	os.close(fd)
except:
	pass
newarglist = sys.argv[:]
EOF

			# disable X11 forwarding which causes .xauth access violations
			# - 20041205 Armando Di Cianno <fafhrd@gentoo.org>
			echo "newarglist.insert(1, '-oClearAllForwardings=yes')" \
				>> "${CVS_RSH}"
			echo "newarglist.insert(1, '-oForwardX11=no')" \
				>> "${CVS_RSH}"

			# Handle SSH host key checking

			local CVS_ECLASS_KNOWN_HOSTS="${T}/cvs_ssh_known_hosts"
			echo "newarglist.insert(1, '-oUserKnownHostsFile=${CVS_ECLASS_KNOWN_HOSTS}')" \
				>> "${CVS_RSH}"

			if [[ -z ${ECVS_SSH_HOST_KEY} ]] ; then
				ewarn "Warning: The SSH host key of the remote server will not be verified."
				einfo "A temporary known hosts list will be used."
				local CVS_ECLASS_STRICT_HOST_CHECKING="no"
				touch "${CVS_ECLASS_KNOWN_HOSTS}"
			else
				local CVS_ECLASS_STRICT_HOST_CHECKING="yes"
				echo "${ECVS_SSH_HOST_KEY}" > "${CVS_ECLASS_KNOWN_HOSTS}"
			fi

			echo -n "newarglist.insert(1, '-oStrictHostKeyChecking=" \
				>> "${CVS_RSH}"
			echo "${CVS_ECLASS_STRICT_HOST_CHECKING}')" \
				>> "${CVS_RSH}"
			echo "os.execv('${EPREFIX}/usr/bin/ssh', newarglist)" \
				>> "${CVS_RSH}"

			chmod a+x "${CVS_RSH}"

			# Make sure DISPLAY is set (SSH will not use SSH_ASKPASS
			# if DISPLAY is not set)

			: ${DISPLAY:="DISPLAY"}
			export DISPLAY

			# Create a dummy executable to echo ${ECVS_PASS}

			export SSH_ASKPASS="${T}/cvs_sshechopass"
			if [[ ${ECVS_AUTH} != "no" ]] ; then
				echo -en "#!/bin/bash\necho \"${ECVS_PASS}\"\n" \
					> "${SSH_ASKPASS}"
			else
				echo -en "#!/bin/bash\nreturn\n" \
					> "${SSH_ASKPASS}"
			fi
			chmod a+x "${SSH_ASKPASS}"
		fi

		if [[ ${mode} == "update" ]] ; then
			einfo "Running ${cmdupdate[*]}"
			"${cmdupdate[@]}" || die "cvs update command failed"
		elif [[ ${mode} == "checkout" ]] ; then
			einfo "Running ${cmdcheckout[*]}"
			"${cmdcheckout[@]}" || die "cvs checkout command failed"
		fi

		# Restore environment variable values
		export CVS_RSH="${CVS_ECLASS_ORIG_CVS_RSH}"
		if [[ ${CVS_ECLASS_ORIG_SSH_ASKPASS+set} == "set" ]] ; then
			export SSH_ASKPASS="${CVS_ECLASS_ORIG_SSH_ASKPASS}"
		else
			unset SSH_ASKPASS
		fi

		if [[ ${CVS_ECLASS_ORIG_DISPLAY+set} == "set" ]] ; then
			export DISPLAY="${CVS_ECLASS_ORIG_DISPLAY}"
		else
			unset DISPLAY
		fi
	fi
}

# @FUNCTION: cvs_src_unpack
# @DESCRIPTION:
# The cvs src_unpack function, which will be exported
cvs_src_unpack() {

	debug-print-function ${FUNCNAME} "$@"

	debug-print "${FUNCNAME}: init:
	ECVS_CVS_COMMAND=${ECVS_CVS_COMMAND}
	ECVS_UP_OPTS=${ECVS_UP_OPTS}
	ECVS_CO_OPTS=${ECVS_CO_OPTS}
	ECVS_TOP_DIR=${ECVS_TOP_DIR}
	ECVS_SERVER=${ECVS_SERVER}
	ECVS_USER=${ECVS_USER}
	ECVS_PASS=${ECVS_PASS}
	ECVS_MODULE=${ECVS_MODULE}
	ECVS_LOCAL=${ECVS_LOCAL}
	ECVS_LOCALNAME=${ECVS_LOCALNAME}"

	[[ -z ${ECVS_MODULE} ]] && die "ERROR: CVS module not set, cannot continue."

	local ECVS_LOCALNAME=${ECVS_LOCALNAME:-${ECVS_MODULE}}

	local sanitized_pn=$(echo "${PN}" | LC_ALL=C sed -e 's:[^A-Za-z0-9_]:_:g')
	local offline_pkg_var="ECVS_OFFLINE_${sanitized_pn}"
	if [[ -n ${!offline_pkg_var}${ECVS_OFFLINE} ]] || [[ ${ECVS_SERVER} == "offline" ]] ; then
		# We're not required to fetch anything; the module already
		# exists and shouldn't be updated.
		if [[ -d ${ECVS_TOP_DIR}/${ECVS_LOCALNAME} ]] ; then
			debug-print "${FUNCNAME}: offline mode"
		else
			debug-print "${FUNCNAME}: Offline mode specified but directory ${ECVS_TOP_DIR}/${ECVS_LOCALNAME} not found, exiting with error"
			die "ERROR: Offline mode specified, but directory ${ECVS_TOP_DIR}/${ECVS_LOCALNAME} not found. Aborting."
		fi
	elif [[ -n ${ECVS_SERVER} ]] ; then # ECVS_SERVER!=offline --> real fetching mode
		einfo "Fetching CVS module ${ECVS_MODULE} into ${ECVS_TOP_DIR} ..."
		cvs_fetch
	else # ECVS_SERVER not set
		die "ERROR: CVS server not specified, cannot continue."
	fi

	einfo "Copying ${ECVS_MODULE} from ${ECVS_TOP_DIR} ..."
	debug-print "Copying module ${ECVS_MODULE} local_mode=${ECVS_LOCAL} from ${ECVS_TOP_DIR} ..."

	# This is probably redundant, but best to make sure.
	mkdir -p "${WORKDIR}/${ECVS_LOCALNAME}"

	if [[ -n ${ECVS_LOCAL} ]] ; then
		cp -f "${ECVS_TOP_DIR}/${ECVS_LOCALNAME}"/* "${WORKDIR}/${ECVS_LOCALNAME}"
	else
		cp -Rf "${ECVS_TOP_DIR}/${ECVS_LOCALNAME}" "${WORKDIR}/${ECVS_LOCALNAME}/.."
	fi

	# Not exactly perfect, but should be pretty close #333773
	export ECVS_VERSION=$(
		find "${ECVS_TOP_DIR}/${ECVS_LOCALNAME}/" -ipath '*/CVS/Entries' -exec cat {} + | \
			LC_ALL=C sort | \
			sha1sum | \
			awk '{print $1}'
	)

	# If the directory is empty, remove it; empty directories cannot
	# exist in cvs.  This happens when, for example, kde-source
	# requests module/doc/subdir which doesn't exist.  Still create
	# the empty directory in workdir though.
	if [[ $(ls -A "${ECVS_TOP_DIR}/${ECVS_LOCALNAME}") == "CVS" ]] ; then
		debug-print "${FUNCNAME}: removing empty CVS directory ${ECVS_LOCALNAME}"
		rm -rf "${ECVS_TOP_DIR}/${ECVS_LOCALNAME}"
	fi

	einfo "CVS module ${ECVS_MODULE} is now in ${WORKDIR}"
}

EXPORT_FUNCTIONS src_unpack

fi

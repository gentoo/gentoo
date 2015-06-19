# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-2.2.8-r2.ebuild,v 1.2 2015/04/25 18:32:08 zmedico Exp $

# Require EAPI 2 since we now require at least python-2.6 (for python 3
# syntax support) which also requires EAPI 2.
EAPI=2
PYTHON_COMPAT=(
	pypy2_0
	python3_2 python3_3 python3_4
	python2_6 python2_7
)
inherit eutils multilib

DESCRIPTION="Portage is the package management and distribution system for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
SLOT="0"
IUSE="build doc epydoc +ipc linguas_ru pypy2_0 python2 python3 selinux xattr"

for _pyimpl in ${PYTHON_COMPAT[@]} ; do
	IUSE+=" python_targets_${_pyimpl}"
done
unset _pyimpl

# Import of the io module in python-2.6 raises ImportError for the
# thread module if threading is disabled.
python_dep_ssl="python3? ( =dev-lang/python-3*[ssl] )
	!pypy2_0? ( !python2? ( !python3? (
		|| ( >=dev-lang/python-2.7[ssl] dev-lang/python:2.6[threads,ssl] )
	) ) )
	pypy2_0? ( !python2? ( !python3? ( virtual/pypy:2.0[bzip2] ) ) )
	python2? ( !python3? ( || ( dev-lang/python:2.7[ssl] dev-lang/python:2.6[ssl,threads] ) ) )"
python_dep="${python_dep_ssl//\[ssl\]}"
python_dep="${python_dep//,ssl}"
python_dep="${python_dep//ssl,}"

python_dep="${python_dep}
	python_targets_pypy2_0? ( virtual/pypy:2.0 )
	python_targets_python2_6? ( dev-lang/python:2.6 )
	python_targets_python2_7? ( dev-lang/python:2.7 )
	python_targets_python3_2? ( dev-lang/python:3.2 )
	python_targets_python3_3? ( dev-lang/python:3.3 )
	python_targets_python3_4? ( dev-lang/python:3.4 )
"

# The pysqlite blocker is for bug #282760.
# make-3.82 is for bug #455858
DEPEND="${python_dep}
	>=sys-devel/make-3.82
	>=sys-apps/sed-4.0.5 sys-devel/patch
	doc? ( app-text/xmlto ~app-text/docbook-xml-dtd-4.4 )
	epydoc? ( >=dev-python/epydoc-2.0 !<=dev-python/pysqlite-2.4.1 )"
# Require sandbox-2.2 for bug #288863.
# For xattr, we can spawn getfattr and setfattr from sys-apps/attr, but that's
# quite slow, so it's not considered in the dependencies as an alternative to
# to python-3.3 / pyxattr. Also, xattr support is only tested with Linux, so
# for now, don't pull in xattr deps for other kernels.
# For whirlpool hash, require python[ssl] or python-mhash (bug #425046).
# For compgen, require bash[readline] (bug #445576).
RDEPEND="${python_dep}
	!build? ( >=sys-apps/sed-4.0.5
		app-shells/bash:0[readline]
		>=app-admin/eselect-1.2
		|| ( ${python_dep_ssl} dev-python/python-mhash )
	)
	elibc_FreeBSD? ( sys-freebsd/freebsd-bin )
	elibc_glibc? ( >=sys-apps/sandbox-2.2 )
	elibc_uclibc? ( >=sys-apps/sandbox-2.2 )
	>=app-misc/pax-utils-0.1.17
	selinux? ( || ( >=sys-libs/libselinux-2.0.94[python] <sys-libs/libselinux-2.0.94 ) )
	xattr? ( kernel_linux? (
		$(for python_impl in python{2_6,2_7,3_2} pypy2_0; do
			echo "python_targets_${python_impl}? ( dev-python/pyxattr[python_targets_${python_impl}] )"
		done) ) )
	!<app-admin/logrotate-3.8.0"
PDEPEND="
	!build? (
		>=net-misc/rsync-2.6.4
		userland_GNU? ( >=sys-apps/coreutils-6.4 )
	)"
# coreutils-6.4 rdep is for date format in emerge-webrsync #164532
# NOTE: FEATURES=installsources requires debugedit and rsync

SRC_ARCHIVES="http://dev.gentoo.org/~dolsen/releases/portage"

prefix_src_archives() {
	local x y
	for x in ${@}; do
		for y in ${SRC_ARCHIVES}; do
			echo ${y}/${x}
		done
	done
}

PV_PL="2.1.2"
PATCHVER_PL=""
TARBALL_PV=${PV}
SRC_URI="mirror://gentoo/${PN}-${TARBALL_PV}.tar.bz2
	$(prefix_src_archives ${PN}-${TARBALL_PV}.tar.bz2)"

PATCHVER=
[[ $TARBALL_PV = $PV ]] || PATCHVER=$PV
if [ -n "${PATCHVER}" ]; then
	SRC_URI="${SRC_URI} mirror://gentoo/${PN}-${PATCHVER}.patch.bz2
	$(prefix_src_archives ${PN}-${PATCHVER}.patch.bz2)"
fi

S="${WORKDIR}"/${PN}-${TARBALL_PV}
S_PL="${WORKDIR}"/${PN}-${PV_PL}

compatible_python_is_selected() {
	[[ $("${EPREFIX}/usr/bin/python" -c 'import sys ; sys.stdout.write(sys.hexversion >= 0x2060000 and "good" or "bad")') = good ]]
}

current_python_has_xattr() {
	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'
	local PYTHON=${EPREFIX}/usr/bin/${EPYTHON}
	[[ $("${PYTHON}" -c 'import sys ; sys.stdout.write(sys.hexversion >= 0x3030000 and "yes" or "no")') = yes ]] || \
	"${PYTHON}" -c 'import xattr' 2>/dev/null
}

call_with_python_impl() {
	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'
	env EPYTHON=${EPYTHON} "$@"
}

get_python_interpreter() {
	[ $# -eq 1 ] || die "expected 1 argument, got $#: $*"
	local impl=$1 python
	case "${impl}" in
		python*)
			python=${impl/_/.}
			;;
		pypy*)
			python=${impl/_/.}
			python=${python/pypy/pypy-c}
			;;
		*)
			die "Unrecognized python target: ${impl}"
	esac
	echo ${python}
}

get_python_sitedir() {
	[ $# -eq 1 ] || die "expected 1 argument, got $#: $*"
	local impl=$1
	local site_dir=usr/$(get_libdir)/${impl/_/.}/site-packages
	[[ -d ${EROOT:-${ROOT}}${site_dir} ]] || \
		ewarn "site-packages dir missing for ${impl}: ${EROOT:-${ROOT}}${site_dir}"
	echo "/${site_dir}"
}

python_compileall() {
	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'
	local d=${EPREFIX}$1 PYTHON=${EPREFIX}/usr/bin/${EPYTHON}
	local d_image=${D}${d#/}
	[[ -d ${d_image} ]] || die "directory does not exist: ${d_image}"
	case "${EPYTHON}" in
		python*)
			"${PYTHON}" -m compileall -q -f -d "${d}" "${d_image}" || die
			# Note: Using -OO breaks emaint, since it requires __doc__,
			# and __doc__ is None when -OO is used.
			"${PYTHON}" -O -m compileall -q -f -d "${d}" "${d_image}" || die
			;;
		pypy*)
			"${PYTHON}" -m compileall -q -f -d "${d}" "${d_image}" || die
			;;
		*)
			die "Unrecognized EPYTHON value: ${EPYTHON}"
	esac
}

pkg_setup() {
	if use python2 && use python3 ; then
		ewarn "Both python2 and python3 USE flags are enabled, but only one"
		ewarn "can be in the shebangs. Using python3."
	fi
	if use pypy2_0 && use python3 ; then
		ewarn "Both pypy2_0 and python3 USE flags are enabled, but only one"
		ewarn "can be in the shebangs. Using python3."
	fi
	if use pypy2_0 && use python2 ; then
		ewarn "Both pypy2_0 and python2 USE flags are enabled, but only one"
		ewarn "can be in the shebangs. Using python2"
	fi
	if ! use pypy2_0 && ! use python2 && ! use python3 && \
		! compatible_python_is_selected ; then
		ewarn "Attempting to select a compatible default python interpreter"
		local x success=0
		for x in "${EPREFIX}"/usr/bin/python2.* ; do
			x=${x#${EPREFIX}/usr/bin/python2.}
			if [[ $x -ge 6 ]] 2>/dev/null ; then
				eselect python set python2.$x
				if compatible_python_is_selected ; then
					elog "Default python interpreter is now set to python-2.$x"
					success=1
					break
				fi
			fi
		done
		if [ $success != 1 ] ; then
			eerror "Unable to select a compatible default python interpreter!"
			die "This version of portage requires at least python-2.6 to be selected as the default python interpreter (see \`eselect python --help\`)."
		fi
	fi

	# We use EPYTHON to designate the active python interpreter,
	# but we only export when needed, via call_with_python_impl.
	EPYTHON=python
	export -n EPYTHON
	if use python3; then
		EPYTHON=python3
	elif use python2; then
		EPYTHON=python2
	elif use pypy2_0; then
		EPYTHON=pypy-c2.0
	fi
}

src_prepare() {
	if [ -n "${PATCHVER}" ] ; then
		if [[ -L $S/bin/ebuild-helpers/portageq ]] ; then
			rm "$S/bin/ebuild-helpers/portageq" \
				|| die "failed to remove portageq helper symlink"
		fi
		epatch "${WORKDIR}/${PN}-${PATCHVER}.patch"
	fi
	einfo "Setting portage.VERSION to ${PVR} ..."
	sed -e "s/^VERSION=.*/VERSION=\"${PVR}\"/" -i pym/portage/__init__.py || \
		die "Failed to patch portage.VERSION"
	sed -e "1s/VERSION/${PVR}/" -i doc/fragment/version || \
		die "Failed to patch VERSION in doc/fragment/version"
	sed -e "1s/VERSION/${PVR}/" -i $(find man -type f) || \
		die "Failed to patch VERSION in man page headers"

	if ! use ipc ; then
		einfo "Disabling ipc..."
		sed -e "s:_enable_ipc_daemon = True:_enable_ipc_daemon = False:" \
			-i pym/_emerge/AbstractEbuildProcess.py || \
			die "failed to patch AbstractEbuildProcess.py"
	fi

	if use xattr && use kernel_linux ; then
		einfo "Adding FEATURES=xattr to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} xattr"' >> cnf/make.globals \
			|| die "failed to append to make.globals"
	fi

	local set_shebang=
	if use python3; then
		set_shebang=python3
	elif use python2; then
		set_shebang=python2
	elif use pypy2_0; then
		set_shebang=pypy-c2.0
	fi
	if [[ -n ${set_shebang} ]] ; then
		einfo "Converting shebangs for ${set_shebang}..."
		while read -r -d $'\0' ; do
			local shebang=$(head -n1 "$REPLY")
			if [[ ${shebang} == "#!/usr/bin/python"* ]] ; then
				sed -i -e "1s:python:${set_shebang}:" "$REPLY" || \
					die "sed failed"
			fi
		done < <(find . -type f -print0)
	fi

	if [[ -n ${EPREFIX} ]] ; then
		einfo "Setting portage.const.EPREFIX ..."
		sed -e "s|^\(SANDBOX_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/bin/sandbox\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(FAKEROOT_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/bin/fakeroot\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(BASH_BINARY[[:space:]]*=[[:space:]]*\"\)\(/bin/bash\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(MOVE_BINARY[[:space:]]*=[[:space:]]*\"\)\(/bin/mv\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(PRELINK_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/sbin/prelink\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(EPREFIX[[:space:]]*=[[:space:]]*\"\).*|\\1${EPREFIX}\"|" \
			-i pym/portage/const.py || \
			die "Failed to patch portage.const.EPREFIX"

		einfo "Prefixing shebangs ..."
		while read -r -d $'\0' ; do
			local shebang=$(head -n1 "$REPLY")
			if [[ ${shebang} == "#!"* && ! ${shebang} == "#!${EPREFIX}/"* ]] ; then
				sed -i -e "1s:.*:#!${EPREFIX}${shebang:2}:" "$REPLY" || \
					die "sed failed"
			fi
		done < <(find . -type f -print0)

		einfo "Adjusting make.globals ..."
		sed -e "s|\(/usr/portage\)|${EPREFIX}\\1|" \
			-e "s|^\(PORTAGE_TMPDIR=\"\)\(/var/tmp\"\)|\\1${EPREFIX}\\2|" \
			-i cnf/make.globals || die "sed failed"

		einfo "Adjusting repos.conf ..."
		sed -e "s|^\(main-repo = \).*|\\1gentoo_prefix|" \
			-e "s|^\\[gentoo\\]|[gentoo_prefix]|" \
			-e "s|^\(location = \)\(/usr/portage\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(sync-uri = \).*|\\1rsync://prefix.gentooexperimental.org/gentoo-portage-prefix|" \
			-i cnf/repos.conf || die "sed failed"

		einfo "Adding FEATURES=force-prefix to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} force-prefix"' >> cnf/make.globals \
			|| die "failed to append to make.globals"
	fi

	cd "${S}/cnf" || die
	if [ -f "make.conf.example.${ARCH}".diff ]; then
		patch make.conf.example "make.conf.example.${ARCH}".diff || \
			die "Failed to patch make.conf.example"
	else
		eerror ""
		eerror "Portage does not have an arch-specific configuration for this arch."
		eerror "Please notify the arch maintainer about this issue. Using generic."
		eerror ""
	fi
}

src_compile() {
	if use doc; then
		call_with_python_impl \
		emake docbook || die
	fi

	if use epydoc; then
		einfo "Generating api docs"
		call_with_python_impl \
		emake epydoc || die
	fi
}

src_test() {
	# make files executable, in case they were created by patch
	find bin -type f | xargs chmod +x
	call_with_python_impl \
	emake test || die
}

src_install() {
	call_with_python_impl \
	emake DESTDIR="${D}" \
		sysconfdir="${EPREFIX}/etc" \
		prefix="${EPREFIX}/usr" \
		install || die

	# Use dodoc for compression, since the Makefile doesn't do that.
	dodoc "${S}"/{ChangeLog,NEWS,RELEASE-NOTES} || die

	# Allow external portage API consumers to import portage python modules
	# (this used to be done with PYTHONPATH setting in /etc/env.d).
	# For each of PYTHON_TARGETS, install a tree of *.py symlinks in
	# site-packages, and compile with the corresponding interpreter.
	local impl files mod_dir dest_mod_dir python relative_path x
	for impl in "${PYTHON_COMPAT[@]}" ; do
		use "python_targets_${impl}" || continue
		if use build && [[ ${ROOT} == / &&
			! -x ${EPREFIX}/usr/bin/$(get_python_interpreter ${impl}) ]] ; then
			# Tolerate --nodeps at beginning of stage1 for catalyst
			ewarn "skipping python_targets_${impl}, interpreter not found"
			continue
		fi
		while read -r mod_dir ; do
			cd "${ED:-${D}}usr/lib/portage/pym/${mod_dir}" || die
			files=$(echo *.py)
			if [ -z "${files}" ] || [ "${files}" = "*.py" ]; then
				# __pycache__ directories contain no py files
				continue
			fi
			dest_mod_dir=$(get_python_sitedir ${impl})/${mod_dir}
			dodir "${dest_mod_dir}" || die
			relative_path=../../../lib/portage/pym/${mod_dir}
			x=/${mod_dir}
			while [ -n "${x}" ] ; do
				relative_path=../${relative_path}
				x=${x%/*}
			done
			for x in ${files} ; do
				dosym "${relative_path}/${x}" \
					"${dest_mod_dir}/${x}" || die
			done
		done < <(cd "${ED:-${D}}"usr/lib/portage/pym || die ; find * -type d ! -path "portage/tests*")
		cd "${S}" || die
		EPYTHON=$(get_python_interpreter ${impl}) \
		python_compileall "$(get_python_sitedir ${impl})"
	done

	# Compile /usr/lib/portage/pym with the active interpreter, since portage
	# internal commands force this directory to the beginning of sys.path.
	python_compileall /usr/lib/portage/pym
}

pkg_preinst() {
	if [[ $ROOT == / ]] ; then
		# Run some minimal tests as a sanity check.
		local test_runner=$(find "${ED:-${D}}" -name runTests)
		if [[ -n $test_runner && -x $test_runner ]] ; then
			einfo "Running preinst sanity tests..."
			"$test_runner" || die "preinst sanity tests failed"
		fi
	fi

	if use xattr && ! current_python_has_xattr ; then
		ewarn "For optimal performance in xattr handling, install"
		ewarn "dev-python/pyxattr, or install >=dev-lang/python-3.3 and"
		ewarn "enable USE=python3 for $CATEGORY/$PN."
	fi

	# elog dir must exist to avoid logrotate error for bug #415911.
	# This code runs in preinst in order to bypass the mapping of
	# portage:portage to root:root which happens after src_install.
	keepdir /var/log/portage/elog
	# This is allowed to fail if the user/group are invalid for prefix users.
	if chown portage:portage "${ED:-${D}}"var/log/portage{,/elog} 2>/dev/null ; then
		chmod g+s,ug+rwx "${ED:-${D}}"var/log/portage{,/elog}
	fi

	# If portage-2.1.6 is installed and the preserved_libs_registry exists,
	# assume that the NEEDED.ELF.2 files have already been generated.
	has_version "<=${CATEGORY}/${PN}-2.2_pre7" && \
		! { [ -e "${EROOT:-${ROOT}}"var/lib/portage/preserved_libs_registry ] && \
		has_version ">=${CATEGORY}/${PN}-2.1.6_rc" ; } \
		&& NEEDED_REBUILD_UPGRADE=true || NEEDED_REBUILD_UPGRADE=false

	if has_version "<${CATEGORY}/${PN}-2.1.13" || \
		{
			has_version ">=${CATEGORY}/${PN}-2.2_rc0" && \
			has_version "<${CATEGORY}/${PN}-2.2.0_alpha189"
		} ; then
		USERPRIV_UPGRADE=true
		USERSYNC_UPGRADE=true
		REPOS_CONF_UPGRADE=true
		REPOS_CONF_SYNC=
		type -P portageq >/dev/null 2>&1 && \
			REPOS_CONF_SYNC=$("$(type -P portageq)" envvar SYNC)
	else
		USERPRIV_UPGRADE=false
		USERSYNC_UPGRADE=false
		REPOS_CONF_UPGRADE=false
	fi
}

get_ownership() {
	case ${USERLAND} in
		BSD)
			stat -f '%Su:%Sg' "${1}"
			;;
		*)
			stat -c '%U:%G' "${1}"
			;;
	esac
}

new_config_protect() {
	# Generate a ._cfg file even if the target file
	# does not exist, ensuring that the user will
	# notice the config change.
	local basename=${1##*/}
	local dirname=${1%/*}
	local i=0
	while true ; do
		local filename=$(
			echo -n "${dirname}/._cfg"
			printf "%04d" ${i}
			echo -n "_${basename}"
		)
		[[ -e ${filename} ]] || break
		(( i++ ))
	done
	echo "${filename}"
}

pkg_postinst() {

	if ${REPOS_CONF_UPGRADE} ; then
		einfo "Generating repos.conf"
		local repo_name=
		[[ -f ${PORTDIR}/profiles/repo_name ]] && \
			repo_name=$(< "${PORTDIR}/profiles/repo_name")
		if [[ -z ${REPOS_CONF_SYNC} ]] ; then
			REPOS_CONF_SYNC=$(grep "^sync-uri =" "${EROOT:-${ROOT}}usr/share/portage/config/repos.conf")
			REPOS_CONF_SYNC=${REPOS_CONF_SYNC##* }
		fi
		local sync_type=
		[[ ${REPOS_CONF_SYNC} == git://* ]] && sync_type=git

		if [[ ${REPOS_CONF_SYNC} == cvs://* ]]; then
			sync_type=cvs
			REPOS_CONF_SYNC=${REPOS_CONF_SYNC#cvs://}
		fi

		cat <<-EOF > "${T}/repos.conf"
		[DEFAULT]
		main-repo = ${repo_name:-gentoo}

		[${repo_name:-gentoo}]
		location = ${PORTDIR:-${EPREFIX}/usr/portage}
		sync-type = ${sync_type:-rsync}
		sync-uri = ${REPOS_CONF_SYNC}
		EOF

		[[ ${sync_type} == cvs ]] && echo "sync-cvs-repo = $(<"${PORTDIR}/CVS/Repository")" >> "${T}/repos.conf"

		local dest=${EROOT:-${ROOT}}etc/portage/repos.conf
		if [[ ! -f ${dest} ]] && mkdir -p "${dest}" 2>/dev/null ; then
			dest=${EROOT:-${ROOT}}etc/portage/repos.conf/${repo_name:-gentoo}.conf
		fi
		# Don't install the config update if the desired repos.conf directory
		# and config file exist, since users may accept it blindly and break
		# their config (bug #478726).
		[[ -e ${EROOT:-${ROOT}}etc/portage/repos.conf/${repo_name:-gentoo}.conf ]] || \
			mv "${T}/repos.conf" "$(new_config_protect "${dest}")"

		if [[ ${PORTDIR} == ${EPREFIX}/usr/portage ]] ; then
			einfo "Generating make.conf PORTDIR setting for backward compatibility"
			for dest in "${EROOT:-${ROOT}}etc/make.conf" "${EROOT:-${ROOT}}etc/portage/make.conf" ; do
				[[ -e ${dest} ]] && break
			done
			[[ -d ${dest} ]] && dest=${dest}/portdir.conf
			rm -rf "${T}/make.conf"
			[[ -f ${dest} ]] && cat "${dest}" > "${T}/make.conf"
			cat <<-EOF >> "${T}/make.conf"

			# Set PORTDIR for backward compatibility with various tools:
			#   gentoo-bashcomp - bug #478444
			#   euse - bug #474574
			#   euses and ufed - bug #478318
			PORTDIR="${EPREFIX}/usr/portage"
			EOF
			mkdir -p "${dest%/*}"
			mv "${T}/make.conf" "$(new_config_protect "${dest}")"
		fi
	fi

	if ${NEEDED_REBUILD_UPGRADE} ; then
		einfo "rebuilding NEEDED.ELF.2 files"
		local cpv filename line newline
		for cpv in "${EROOT:-${ROOT}}var/db/pkg"/*/*; do
			[[ -f "${cpv}/NEEDED" && ! -f "${cpv}/NEEDED.ELF.2" ]] || continue
			while read -r line; do
				filename=${line% *}
				newline=$(scanelf -BF "%a;%F;%S;%r;%n" "${ROOT%/}${filename}")
				newline=${newline//  -  }
				[[ ${#ROOT} -gt 1 ]] && newline=${newline/${ROOT%/}}
				echo "${newline:3}" >> "${cpv}/NEEDED.ELF.2"
			done < "${cpv}/NEEDED"
		done
	fi

	local distdir=${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}

	if ${USERSYNC_UPGRADE} && \
		[[ -d ${PORTDIR} && -w ${PORTDIR} ]] ; then
		local ownership=$(get_ownership "${PORTDIR}")
		if [[ -n ${ownership} ]] ; then
			einfo "Adjusting PORTDIR permissions for usersync"
			find "${PORTDIR}" -path "${distdir%/}" -prune -o \
				! \( -user "${ownership%:*}" -a -group "${ownership#*:}" \) \
				-exec chown "${ownership}" {} +
		fi
	fi

	# Do this last, since it could take a long time if there
	# are lots of live sources, and the user may be tempted
	# to kill emerge while it is running.
	if ${USERPRIV_UPGRADE} && \
		[[ -d ${distdir} && -w ${distdir} ]] ; then
		local ownership=$(get_ownership "${distdir}")
		if [[ ${ownership#*:} == portage ]] ; then
			einfo "Adjusting DISTDIR permissions for userpriv"
			find "${distdir}" -mindepth 1 -maxdepth 1 -type d -uid 0 \
				-exec chown -R portage:portage {} +
		fi
	fi
}

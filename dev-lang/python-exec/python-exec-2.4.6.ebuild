# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Kids, don't do this at home!
inherit python-utils-r1
PYTHON_COMPAT=( "${_PYTHON_ALL_IMPLS[@]}" )

# Inherited purely to have PYTHON_TARGET flags which will satisfy USE
# dependencies and trigger necessary rebuilds.
inherit python-r1

DESCRIPTION="Python script wrapper"
HOMEPAGE="https://github.com/mgorny/python-exec/"
SRC_URI="https://github.com/mgorny/python-exec/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# eselect-python because of /usr/bin/python* collisions and new config
# python versions because of missing $scriptdir/python* symlinks
RDEPEND="
	!<app-eselect/eselect-python-20160206
	!<dev-lang/python-2.7.10-r4:2.7
	!<dev-lang/python-3.3.5-r4:3.3
	!<dev-lang/python-3.4.3-r4:3.4
	!<dev-lang/python-3.5.0-r3:3.5"

src_configure() {
	local pyimpls=() i EPYTHON
	for i in "${PYTHON_COMPAT[@]}"; do
		python_export "${i}" EPYTHON
		pyimpls+=( "${EPYTHON}" )
	done

	local myconf=(
		--with-fallback-path="${EPREFIX}/usr/local/sbin:${EPREFIX}/usr/local/bin:${EPREFIX}/usr/sbin:${EPREFIX}/usr/bin:${EPREFIX}/sbin:${EPREFIX}/bin"
		--with-python-impls="${pyimpls[*]}"
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	# Prepare and own the template
	insinto /etc/python-exec
	newins - python-exec.conf \
		< <(sed -n -e '/^#/p' config/python-exec.conf.example)

	local f
	for f in python{,2,3}; do
		# symlink the C wrapper for python to avoid shebang recursion
		# bug #568974
		dosym python-exec2c /usr/bin/"${f}"
	done
	for f in python{,2,3}-config 2to3 idle pydoc pyvenv; do
		# those are python scripts (except for new python-configs)
		# so symlink them via the python wrapper
		dosym ../lib/python-exec/python-exec2 /usr/bin/"${f}"
	done
}

pkg_preinst() {
	if [[ -e ${EROOT}etc/python-exec/python-exec.conf ]]; then
		# preserve current configuration
		cp "${EROOT}"etc/python-exec/python-exec.conf \
			"${ED}"etc/python-exec/python-exec.conf || die
	else
		# preserve previous Python version preference
		local py old_pythons=()
		local config_base=${EROOT}etc/env.d/python

		# start with the 'global' preference (2 vs 3)
		if [[ -f ${config_base}/config ]]; then
			old_pythons+=( "$(<${config_base}/config)" )
		fi

		# then try specific py3 selection
		for py in 3; do
			local target=

			if [[ -f ${config_base}/python${py} ]]; then
				# try the newer config files
				target=$(<${config_base}/python${py})
			elif [[ -L ${EROOT}/usr/bin/python${py} ]]; then
				# check the older symlink format
				target=$(readlink "${EROOT}/usr/bin/python${py}")

				# check if it's actually old eselect symlink
				[[ ${target} == python?.? ]] || target=
			fi

			# add the extra target if found and != global
			if [[ ${target} && ${old_pythons[0]} != ${target} ]]; then
				old_pythons+=( "${target}" )
			fi
		done

		if [[ ${old_pythons[@]} ]]; then
			elog "You seem to have just upgraded into the new version of python-exec"
			elog "that uses python-exec.conf for configuration. The ebuild has attempted"
			elog "to convert your previous configuration to the new format, resulting"
			elog "in the following preferences (most preferred version first):"
			elog
			for py in "${old_pythons[@]}"; do
				elog "  ${py}"
			done
			elog
			elog "Those interpreters will be preferred when running Python scripts or"
			elog "calling wrapped Python executables (python, python2, pydoc...)."
			elog "If none of the preferred interpreters are supported, python-exec will"
			elog "fall back to the newest supported Python version."
			elog
			elog "Please note that due to the ambiguous character of the old settings,"
			elog "you may want to modify the preference list yourself. In order to do so,"
			elog "open the following file in your favorite editor:"
			elog
			elog "  ${EROOT}etc/python-exec/python-exec.conf"
			elog
			elog "For more information on the new configuration format, please read"
			elog "the comment on top of the installed configuration file."

			local IFS=$'\n'
			echo "${old_pythons[*]}" \
				>> "${ED}"etc/python-exec/python-exec.conf || die
		fi
	fi
}

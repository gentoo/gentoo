# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=(
	pypy
	python3_3 python3_4 python3_5
	python2_7
)
PYTHON_REQ_USE='bzip2(+)'

inherit distutils-r1 eutils multilib

DESCRIPTION="Repoman is a Quality Assurance tool for Gentoo ebuilds"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
SLOT="0"
IUSE=""

DEPEND="dev-lang/python-exec:2"

RDEPEND="
	dev-lang/python-exec:2
	!<sys-apps/portage-2.3.0_rc
	>=dev-python/lxml-3.6.0
	"

SRC_ARCHIVES="https://dev.gentoo.org/~dolsen/releases/repoman"

prefix_src_archives() {
	local x y
	for x in ${@}; do
		for y in ${SRC_ARCHIVES}; do
			echo ${y}/${x}
		done
	done
}

TARBALL_PV=${PV}
SRC_URI="mirror://gentoo/${PN}-${TARBALL_PV}.tar.bz2
	$(prefix_src_archives ${PN}-${TARBALL_PV}.tar.bz2)
	https://gitweb.gentoo.org/proj/portage.git/patch/?id=ef33db45a0c1d462411d4ced1857a322c0ab28f6 -> repoman-2.3.0-bug-586864.patch"

python_prepare_all() {
	epatch "${DISTDIR}/repoman-2.3.0-bug-586864.patch"
	distutils-r1_python_prepare_all

	if [[ -n ${EPREFIX} ]] ; then
		einfo "Prefixing shebangs ..."
		while read -r -d $'\0' ; do
			local shebang=$(head -n1 "$REPLY")
			if [[ ${shebang} == "#!"* && ! ${shebang} == "#!${EPREFIX}/"* ]] ; then
				sed -i -e "1s:.*:#!${EPREFIX}${shebang:2}:" "$REPLY" || \
					die "sed failed"
			fi
		done < <(find . -type f -print0)
	fi
}

python_test() {
	esetup.py test
}

python_install() {
	# Install sbin scripts to bindir for python-exec linking
	# they will be relocated in pkg_preinst()
	distutils-r1_python_install \
		--system-prefix="${EPREFIX}/usr" \
		--bindir="$(python_get_scriptdir)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--sbindir="$(python_get_scriptdir)" \
		--sysconfdir="${EPREFIX}/etc" \
		"${@}"
}

python_install_all() {
	distutils-r1_python_install_all
}

pkg_postinst() {
	einfo ""
	einfo "This release of repoman is from the new portage/repoman split"
	einfo "release code base."
	einfo "This new repoman code base is still being developed.  So its API's"
	einfo "are not to be considered stable and are subject to change."
	einfo "The code released has been tested and considered ready for use."
	einfo "This however does not guarantee it to be completely bug free."
	einfo "Please report any bugs you may encounter."
	einfo ""
}

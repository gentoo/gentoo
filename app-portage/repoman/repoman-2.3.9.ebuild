# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE='bzip2(+)'

inherit distutils-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/portage.git"
	S="${WORKDIR}/${P}/repoman"
else
	SRC_URI="https://dev.gentoo.org/~zmedico/portage/archives/${P}.tar.bz2"
	KEYWORDS="alpha amd64 ~arm arm64 ~hppa ia64 ~mips ppc ~ppc64 s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Repoman is a Quality Assurance tool for Gentoo ebuilds"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	>=sys-apps/portage-2.3.27[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.6.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed 's:FileNotFoundError:EnvironmentError:' -i pym/repoman/config.py || die
	sed 's:file\.size\.fatal:file.size-fatal:' -i pym/repoman/modules/scan/fetch/fetches.py || die
	distutils-r1_src_prepare
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

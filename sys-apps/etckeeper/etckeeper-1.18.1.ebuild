# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils bash-completion-r1 prefix python-r1

DESCRIPTION="A collection of tools to let /etc be stored in a repository"
HOMEPAGE="https://etckeeper.branchable.com/"
SRC_URI="https://github.com/joeyh/etckeeper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"
SLOT="0"
IUSE="bazaar cron"
REQUIRED_USE="bazaar? ( ${PYTHON_REQUIRED_USE} )"

VCS_DEPEND="dev-vcs/git
	dev-vcs/mercurial
	dev-vcs/darcs"
DEPEND="bazaar? ( dev-vcs/bzr )"
RDEPEND="${DEPEND}
	app-portage/portage-utils
	cron? ( virtual/cron )
	bazaar? ( ${PYTHON_DEPS} )
	!bazaar? ( || ( ${VCS_DEPEND} ) )"

src_prepare(){
	epatch "${FILESDIR}"/${PN}-1.18-gentoo.patch
}

src_compile() {
	:
}

src_install(){
	emake DESTDIR="${ED}" install

	bzr_install() {
		${PYTHON} ./${PN}-bzr/__init__.py install --root="${ED}" ||
			die "bzr support installation failed!"
	}
	use bazaar && python_foreach_impl bzr_install

	if use prefix; then
		doenvd "${FILESDIR}"/99${PN}
		eprefixify "${ED%/}"/etc/env.d/99${PN}
	fi

	newbashcomp bash_completion ${PN}
	dodoc doc/README.mdwn
	docinto examples
	newdoc "${FILESDIR}"/bashrc-r1 bashrc

	if use cron ; then
		exeinto /etc/cron.daily
		newexe debian/cron.daily etckeeper
	fi
}

pkg_postinst(){
	elog "${PN} supports the following VCS: ${VCS_DEPEND}"
	elog "	dev-vcs/bzr"
	elog "This ebuild just ensures at least one is installed!"
	elog "For dev-vcs/bzr you need to enable 'bazaar' useflag."
	elog
	elog "You may want to adjust your /etc/portage/bashrc"
	elog "see the example file in /usr/share/doc/${PF}/examples"
	elog
	elog "To initialise your etc-dir as a repository run:"
	elog "${PN} init -d /etc"
}

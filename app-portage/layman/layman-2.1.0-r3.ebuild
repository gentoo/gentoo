# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
PYTHON_REQ_USE="xml(+)"

inherit eutils distutils-r1 prefix

DESCRIPTION="Tool to manage Gentoo overlays"
HOMEPAGE="http://layman.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~s390 ~sh ~x86 ~ppc-aix ~ppc ~ppc64 ~x86-fbsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris ~sparc"
IUSE="bazaar cvs darcs +git mercurial subversion test"

DEPEND="test? ( dev-vcs/subversion )"

RDEPEND="
	bazaar? ( dev-vcs/bzr )
	cvs? ( dev-vcs/cvs )
	darcs? ( dev-vcs/darcs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	subversion? (
		|| (
			>=dev-vcs/subversion-1.5.4[http]
			>=dev-vcs/subversion-1.5.4[webdav-neon]
			>=dev-vcs/subversion-1.5.4[webdav-serf]
		)
	)
	sys-apps/portage[${PYTHON_USEDEP}]
	>=dev-python/ssl-fetch-0.2[${PYTHON_USEDEP}]
	"

python_prepare_all()  {
	distutils-r1_python_prepare_all
	epatch "${FILESDIR}"/${P}-local_overlay.patch
	epatch "${FILESDIR}"/${P}-incorrect-import-make-conf-fix.patch
	eprefixify etc/layman.cfg layman/config.py
}

python_test() {
	for suite in layman/tests/{dtest,external}.py ; do
		PYTHONPATH="." "${PYTHON}" ${suite} \
				|| die "test suite '${suite}' failed"
	done
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/layman
	doins etc/layman.cfg

	doman doc/layman.8
	dohtml doc/layman.8.html

	keepdir /var/lib/layman
	keepdir /etc/layman/overlays
}

pkg_postinst() {
	# now run layman's update utility
	einfo "Running layman-updater..."
	"${EROOT}"/usr/bin/layman-updater
	einfo
}

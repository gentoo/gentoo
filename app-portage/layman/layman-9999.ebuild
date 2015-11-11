# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )
PYTHON_REQ_USE="xml(+),sqlite?"

inherit eutils distutils-r1 git-2 linux-info prefix

DESCRIPTION="Tool to manage Gentoo overlays"
HOMEPAGE="http://layman.sourceforge.net"
SRC_URI=""
EGIT_REPO_URI="git://anongit.gentoo.org/proj/layman.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bazaar cvs darcs +git gpg g-sorcery mercurial sqlite squashfs subversion sync-plugin-portage test"

DEPEND="test? ( dev-vcs/subversion )
	app-text/asciidoc
	"

RDEPEND="
	bazaar? ( dev-vcs/bzr )
	cvs? ( dev-vcs/cvs )
	darcs? ( dev-vcs/darcs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	g-sorcery? ( app-portage/g-sorcery )
	subversion? (
		|| (
			>=dev-vcs/subversion-1.5.4[http]
			>=dev-vcs/subversion-1.5.4[webdav-neon]
			>=dev-vcs/subversion-1.5.4[webdav-serf]
		)
	)
	gpg? ( =dev-python/pyGPG-9999 )
	sync-plugin-portage?  ( >=sys-apps/portage-2.2.16[${PYTHON_USEDEP}] )
	!sync-plugin-portage? ( sys-apps/portage[${PYTHON_USEDEP}] )
	>=dev-python/ssl-fetch-0.2[${PYTHON_USEDEP}]
	"

layman_check_kernel_config() {
	local CONFIG_CHECK
	use squashfs && CONFIG_CHECK+=" ~BLK_DEV_LOOP ~SQUASHFS"
	[[ -n ${CONFIG_CHECK} ]] && check_extra_config
}

pkg_pretend() {
	layman_check_kernel_config
}

pkg_setup() {
	layman_check_kernel_config
}

python_prepare_all()  {
	python_setup
	esetup.py setup_plugins
	distutils-r1_python_prepare_all
	eprefixify etc/layman.cfg layman/config.py
}

python_test() {
	suite=layman/tests/external.py
	PYTHONPATH="." "${PYTHON}" ${suite} || die "test suite '${suite}' failed"
	unset suite
}

python_compile_all() {
	# override MAKEOPTS to prevent build failure
	emake -j1 -C doc
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

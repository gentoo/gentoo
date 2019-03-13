# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )
PYTHON_REQ_USE="xml(+),sqlite?"

inherit eutils distutils-r1 linux-info prefix

DESCRIPTION="Tool to manage Gentoo overlays"
HOMEPAGE="https://wiki.gentoo.org/wiki/Layman"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="bazaar cvs darcs +git gpg g-sorcery mercurial sqlite squashfs subversion sync-plugin-portage test"

DEPEND="test? ( dev-vcs/subversion )
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
	gpg? ( >=dev-python/pyGPG-0.2 )
	sync-plugin-portage? (
		|| (
			>=sys-apps/portage-2.2.16[${PYTHON_USEDEP}]
			sys-apps/portage-mgorny[${PYTHON_USEDEP}]
		)
	)
	!sync-plugin-portage? (
		|| (
			sys-apps/portage[${PYTHON_USEDEP}]
			sys-apps/portage-mgorny[${PYTHON_USEDEP}]
		)
	)
	>=dev-python/ssl-fetch-0.4[${PYTHON_USEDEP}]
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

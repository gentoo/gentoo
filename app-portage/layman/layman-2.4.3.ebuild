# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="xml(+),sqlite?"
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 linux-info prefix

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/layman.git"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Tool to manage Gentoo overlays"
HOMEPAGE="https://wiki.gentoo.org/wiki/Layman"

LICENSE="GPL-2"
SLOT="0"
IUSE="cvs darcs +git gpg g-sorcery mercurial sqlite squashfs subversion sync-plugin-portage test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-vcs/subversion )
	"

RDEPEND="
	cvs? ( dev-vcs/cvs )
	darcs? ( dev-vcs/darcs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	g-sorcery? ( app-portage/g-sorcery )
	subversion? ( >=dev-vcs/subversion-1.5.4[http(+)] )
	gpg? ( >=dev-python/pyGPG-0.2 )
	sync-plugin-portage? ( >=sys-apps/portage-2.2.16[${PYTHON_USEDEP}] )
	!sync-plugin-portage? ( sys-apps/portage[${PYTHON_USEDEP}] )
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

python_prepare_all() {
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
	# Generate man page. only required for 9999
	if [[ ${PV} == *9999 ]] ; then
		# override MAKEOPTS to prevent build failure
		emake -j1 -C doc
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/layman
	doins etc/layman.cfg

	doman doc/layman.8
	docinto html
	dodoc doc/layman.8.html

	keepdir /var/lib/layman
	keepdir /etc/layman/overlays
}

pkg_postinst() {
	# now run layman's update utility
	einfo "Running layman-updater..."
	"${EROOT}"/usr/bin/layman-updater
	einfo
}

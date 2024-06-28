# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/_/-}

if [[ ${PV} == *9999* ]]; then
	SRC_ECLASS="git-r3"
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/catalyst.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://gitweb.gentoo.org/proj/catalyst.git/snapshot/${MY_P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	S="${WORKDIR}/${MY_P/_/-}"
fi

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 linux-info optfeature tmpfiles ${SRC_ECLASS}

DESCRIPTION="Release metatool used for creating releases based on Gentoo Linux"
HOMEPAGE="https://wiki.gentoo.org/wiki/Catalyst"

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc +iso"

BDEPEND="
	app-text/asciidoc
"
DEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
	>=dev-python/snakeoil-0.6.5[${PYTHON_USEDEP}]
	dev-python/fasteners[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	sys-apps/util-linux[python,${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	>=dev-python/pydecomp-0.3[${PYTHON_USEDEP}]
	app-arch/lbzip2
	app-arch/pixz
	app-arch/tar[xattr]
	dev-vcs/git
	sys-fs/dosfstools
	sys-fs/squashfs-tools-ng[tools]

	iso? (
		app-cdr/cdrtools
		dev-libs/libisoburn

		amd64? (
			sys-boot/grub[grub_platforms_efi-32,grub_platforms_efi-64]
			sys-fs/mtools
		)
		arm64?  (
			sys-boot/grub[grub_platforms_efi-64]
			sys-fs/mtools
		)
		ia64?  (
			sys-boot/grub[grub_platforms_efi-64]
			sys-fs/mtools
		)
		ppc?   (
			sys-boot/grub:2[grub_platforms_ieee1275]
		)
		ppc64? (
			sys-boot/grub:2[grub_platforms_ieee1275]
		)
		sparc? (
			sys-boot/grub:2[grub_platforms_ieee1275]
		)
		x86?   (
			sys-boot/grub[grub_platforms_efi-32]
		)
	)
"

pkg_setup() {
	CONFIG_CHECK="
		~UTS_NS ~IPC_NS
		~SQUASHFS ~SQUASHFS_ZLIB
	"
	linux-info_pkg_setup
}

python_prepare_all() {
	python_setup
	echo VERSION="${PV}" "${PYTHON}" setup.py set_version
	VERSION="${PV}" "${PYTHON}" setup.py set_version || die
	distutils-r1_python_prepare_all
}

# Build man pages here so as to not clobber default src_compile
src_configure() {
	# build the man pages and docs
	emake
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		dodoc files/HOWTO.html files/docbook-xsl.css
	fi
}

python_install() {
	distutils-r1_python_install
	rm -rv "${D}"$(python_get_sitedir)/usr
}

src_install() {
	distutils-r1_src_install

	echo 'd /var/tmp/catalyst 0755 root root' > "${T}"/catalyst-tmpdir.conf
	dotmpfiles "${T}"/catalyst-tmpdir.conf

	doman files/catalyst.1 files/catalyst-config.5 files/catalyst-spec.5
	insinto /etc/catalyst
	doins etc/*
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		optfeature "ccache support" dev-util/ccache
	fi
	tmpfiles_process catalyst-tmpdir.conf
}

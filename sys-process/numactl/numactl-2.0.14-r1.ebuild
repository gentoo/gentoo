# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != 2.0.14 ]] ; then
	eerror "Please do not bump to 2.0.15! It's broken:"
	eerror "https://github.com/numactl/numactl/issues/135"
	eerror "It's also missing a dist tarball:"
	eerror "https://github.com/numactl/numactl/issues/140"
	die "Please check ebuild!"
fi

inherit autotools multilib-minimal

DESCRIPTION="Utilities and libraries for NUMA systems"
HOMEPAGE="https://github.com/numactl/numactl"
if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/numactl/numactl.git"
else
	SRC_URI="https://github.com/numactl/numactl/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.14-latomic.patch
	"${FILESDIR}"/${PN}-2.0.14-numademo-cflags.patch # bug #540856
)

src_prepare() {
	default

	eautoreconf

	# We need to copy the sources or else tests will fail
	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_compile() {
	multilib_is_native_abi && default || emake libnuma.la
}

multilib_src_test() {
	if multilib_is_native_abi ; then
		if [[ -d /sys/devices/system/node ]] ; then
			einfo "The only generically safe test is regress2."
			einfo "The other test cases require 2 NUMA nodes."
			emake regress2
		else
			ewarn "You do not have baseline NUMA support in your kernel, skipping tests."
		fi
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" \
		install$(multilib_is_native_abi || echo "-libLTLIBRARIES install-includeHEADERS")
	find "${ED}"/usr/ -type f -name libnuma.la -delete || die
}

multilib_src_install_all() {
	local DOCS=( README.md )
	einstalldocs

	# Delete man pages provided by the man-pages package, bug #238805
	rm -r "${ED}"/usr/share/man/man[25] || die
}

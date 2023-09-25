# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="A software-based managed Ethernet switch for planet Earth"
HOMEPAGE="https://www.zerotier.com/"
SRC_URI="https://github.com/zerotier/ZeroTierOne/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/ZeroTierOne-${PV}

LICENSE="BUSL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="cpu_flags_arm_neon"

RDEPEND="
	dev-libs/json-glib
	net-libs/libnatpmp
	>=net-libs/miniupnpc-2:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10.1-respect-ldflags.patch
	"${FILESDIR}"/${PN}-1.10.1-add-armv7a-support.patch
)

DOCS=( README.md AUTHORS.md )

src_configure() {
	tc-export CXX CC

	append-ldflags -Wl,-z,noexecstack

	use cpu_flags_arm_neon || export ZT_DISABLE_NEON=1
}

src_compile() {
	myemakeargs=(
		CXX="${CXX}"
		STRIP=:

		# Needs Rust and fails to build as of 1.10.1
		ZT_SSO_SUPPORTED=0
	)

	emake "${myemakeargs[@]}" one
}

src_test() {
	emake "${myemakeargs[@]}" selftest
	./zerotier-selftest || die
}

src_install() {
	default

	# Remove pre-zipped man pages
	rm "${ED}"/usr/share/man/{man1,man8}/* || die

	newinitd "${FILESDIR}/${PN}".init-r1 "${PN}"
	systemd_dounit "${FILESDIR}/${PN}".service

	doman doc/zerotier-{cli.1,idtool.1,one.8}
}

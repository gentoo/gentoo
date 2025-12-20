# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1

MY_P=${PN}-${PV/_rc/rc}
DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
HOMEPAGE="https://mosh.org"
#SRC_URI="https://mosh.org/${P}.tar.gz"
SRC_URI="https://github.com/mobile-shell/mosh/releases/download/${MY_P}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~arm64-macos ~x64-macos"
fi
IUSE="+client examples +hardened nettle +server syslog ufw +utempter"

REQUIRED_USE="
	|| ( client server )
	examples? ( client )"

# depends on abseil-cpp via protobuf targets
RDEPEND="
	dev-cpp/abseil-cpp:=
	dev-libs/protobuf:=
	sys-libs/ncurses:=
	virtual/zlib:=
	virtual/ssh
	client? (
		dev-lang/perl
		dev-perl/IO-Tty
	)
	!nettle? ( dev-libs/openssl:= )
	nettle? ( dev-libs/nettle:= )
	utempter? (
		sys-libs/libutempter
	)"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

QA_CONFIGURE_OPTIONS="--disable-static"

# [0] - avoid sandbox-violation calling git describe in Makefile.
PATCHES=(
	"${FILESDIR}"/${PN}-1.2.5-git-version.patch
)

src_prepare() {
	default

	# abseil-cpp needs >=c++14
	local CXXSTD="14"
	if has_version ">=dev-cpp/abseil-cpp-20240722.0"; then
		# needs >=c++17
		CXXSTD="17"
	fi
	sed -e "/AX_CXX_COMPILE_STDCXX/{s/11/${CXXSTD}/}" -i configure.ac || die

	eautoreconf
}

src_configure() {
	MAKEOPTS+=" V=1"

	local myeconfargs=(
		# We install it ourselves in src_install
		--disable-completion

		$(use_enable client)
		$(use_enable server)
		$(use_enable examples)
		$(use_enable hardened hardening)
		$(use_enable ufw)
		$(use_enable syslog)
		$(use_with utempter)

		# We default to OpenSSL as upstream do
		--with-crypto-library=$(usex nettle nettle openssl-with-openssl-ocb)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find src/examples -type f -perm /0111 -print0 |
	while IFS= read -r -d '' myprog; do
		newbin "${myprog}" "${PN}-$(basename "${myprog}")"
		elog "${myprog} installed as ${PN}-$(basename "${myprog}")"
	done

	# bug #477384
	dobashcomp conf/bash-completion/completions/mosh
}

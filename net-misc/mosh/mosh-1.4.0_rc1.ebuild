# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1

MY_P=${PN}-${PV/_/-}
DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
HOMEPAGE="https://mosh.org"
#SRC_URI="https://mosh.org/${P}.tar.gz"
SRC_URI="https://github.com/mobile-shell/mosh/releases/download/${MY_P}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
fi
IUSE="+client examples +mosh-hardening +server syslog ufw +utempter"

REQUIRED_USE="
	|| ( client server )
	examples? ( client )"

RDEPEND="
	dev-libs/openssl:=
	dev-libs/protobuf:=
	sys-libs/ncurses:=
	sys-libs/zlib
	virtual/ssh
	client? (
		dev-lang/perl
		dev-perl/IO-Tty
	)
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
		$(use_enable ufw)
		$(use_enable mosh-hardening hardening)
		$(use_enable syslog)
		$(use_with utempter)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	for myprog in $(find src/examples -type f -perm /0111) ; do
		newbin ${myprog} ${PN}-$(basename ${myprog})
		elog "${myprog} installed as ${PN}-$(basename ${myprog})"
	done

	# bug #477384
	dobashcomp conf/bash-completion/completions/mosh
}

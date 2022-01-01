# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools bash-completion-r1 git-r3

DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
HOMEPAGE="https://mosh.org"
EGIT_REPO_URI="https://github.com/keithw/mosh.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="+client examples libressl +mosh-hardening +server ufw +utempter"

REQUIRED_USE="
	|| ( client server )
	examples? ( client )"

RDEPEND="
	dev-libs/protobuf:0=
	sys-libs/ncurses:0=
	virtual/ssh
	client? (
		dev-lang/perl
		dev-perl/IO-Tty
	)
	libressl? (
		dev-libs/libressl:0=
	)
	!libressl? (
		dev-libs/openssl:0=
	)
	utempter? (
		sys-libs/libutempter
	)"

DEPEND="${RDEPEND}
	dev-vcs/git[curl]
	virtual/pkgconfig"

# [0] - avoid sandbox-violation calling git describe in Makefile
PATCHES=(
	"${FILESDIR}"/${PN}-1.2.5-git-version.patch
)

src_prepare() {
	MAKEOPTS+=" V=1"
	default

	eautoreconf
}

src_configure() {
	econf \
		--disable-completion \
		$(use_enable client) \
		$(use_enable server) \
		$(use_enable examples) \
		$(use_enable ufw) \
		$(use_enable mosh-hardening hardening) \
		$(use_with utempter)
}

src_install() {
	default

	for myprog in $(find src/examples -type f -perm /0111) ; do
		newbin ${myprog} ${PN}-$(basename ${myprog})
		elog "${myprog} installed as ${PN}-$(basename ${myprog})"
	done

	# bug 477384
	dobashcomp conf/bash-completion/completions/mosh
}

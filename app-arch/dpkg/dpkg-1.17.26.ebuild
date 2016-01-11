# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib autotools toolchain-funcs

DESCRIPTION="Package maintenance system for Debian"
HOMEPAGE="http://packages.qa.debian.org/dpkg"
SRC_URI="mirror://debian/pool/main/d/${PN}/${P/-/_}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-solaris ~x86-solaris"
IUSE="+bzip2 +lzma nls selinux test unicode +update-alternatives +zlib"

RDEPEND="
	>=dev-lang/perl-5.6.0:=
	dev-perl/TimeDate
	>=sys-libs/ncurses-5.2-r7
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	selinux? ( sys-libs/libselinux )
	zlib? ( >=sys-libs/zlib-1.1.4 )
"
DEPEND="
	${RDEPEND}
	app-arch/xz-utils
	sys-devel/flex
	virtual/pkgconfig
	nls? (
		app-text/po4a
		>=sys-devel/gettext-0.18.2
	)
	test? (
		dev-perl/DateTime-Format-DateParse
		dev-perl/IO-String
		dev-perl/Test-Pod
		virtual/perl-Test-Harness
	)
"

DOCS=( ChangeLog THANKS TODO )

src_prepare() {
	# do not expect Debian's gzip --rsyncable extension
	epatch "${FILESDIR}"/${PN}-1.17.0-gzip-rsyncable.patch

	epatch "${FILESDIR}"/${PN}-1.17.1-flags.patch

	# Force the use of the running bash for get-version (this file is never
	# installed, so no need to worry about hardcoding a temporary bash)
	sed -i -e '1c\#!'"${BASH}" get-version || die

	if [[ ${CHOST} == mips64*-linux-gnu ]] ; then
		# Debian targets use custom full tuples.  Map the default one
		# based on the ABI we're using.
		local abi
		if [[ ${ABI} == "n64" ]] ; then
			abi="mips64"
		else
			abi="mipsn32"
		fi
		printf "gnu-linux-mips64 ${abi}\ngnu-linux-mips64el ${abi}el\n" >> triplettable
	fi

	use nls && strip-linguas -i po

	eautoreconf
}

src_configure() {
	tc-export CC
	econf \
		$(use_enable nls) \
		$(use_enable unicode) \
		$(use_enable update-alternatives) \
		$(use_with bzip2 bz2) \
		$(use_with lzma liblzma) \
		$(use_with selinux) \
		$(use_with zlib) \
		--disable-compiler-warnings \
		--disable-dselect \
		--disable-silent-rules \
		--disable-start-stop-daemon \
		--localstatedir="${EPREFIX}"/var
}

src_compile() {
	emake AR=$(tc-getAR)
}

src_install() {
	default

	keepdir /usr/$(get_libdir)/db/methods/{mnt,floppy,disk}
	keepdir /usr/$(get_libdir)/db/{alternatives,info,methods,parts,updates}
}

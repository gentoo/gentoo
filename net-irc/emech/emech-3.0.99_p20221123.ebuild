# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 toolchain-funcs

GIT_COMMIT="62b62c8388fac3b3715c5d6539e1d704b16fa2d6"

DESCRIPTION="UNIX compatible IRC bot programmed in C"
HOMEPAGE="https://github.com/EnergyMech/energymech"
SRC_URI="https://github.com/EnergyMech/energymech/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/energymech-${GIT_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug session tcl"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="virtual/libcrypt:="
DEPEND="${RDEPEND}"

DOC_CONTENTS="You can find a compressed sample config file at /usr/share/doc/${PF}"

PATCHES=( "${FILESDIR}/${P}-fix-Wreturn-type.patch" )
src_prepare() {
	default

	sed -i \
		-e 's:"help/":"/usr/share/energymech/help/":' \
		src/config.h.in || die
	# Respect CFLAGS and LDFLAGS
	sed -i \
		-e '/^LFLAGS/s/\$(PIPEFLAG)/\0 \$(OPTIMIZE) \$(LDFLAGS)/' \
		-e '/^GDBFLAG/d' \
		-e '/^PIPEFLAG/d' \
		src/Makefile.in || die
}

src_configure() {
	tc-export CC
	myconf=(
		--with-alias
		--with-botnet
		--with-bounce
		--with-ctcp
		--with-dccfile
		--with-dynamode
		--with-dyncmd
		--with-greet
		--with-ircd_ext
		--with-md5
		--with-newbie
		--with-note
		--with-notify
		--with-rawdns
		--with-seen
		--with-stats
		--with-telnet
		--with-toybox
		--with-trivia
		--without-uptime
		--with-web
		--with-wingate
		--without-profiling
		--without-redirect
		$(use_with tcl)
		$(use_with session)
		$(use_with debug)
	)
	# not econf because we don't use autotools
	./configure "${myconf[@]}" || die "Configure failed"
}

src_compile() {
	emake -C src CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}"
}

src_install() {
	dobin src/energymech

	insinto /usr/share/energymech
	doins -r help

	insinto /usr/share/energymech/messages
	doins common/*.txt

	dodoc sample.* README* TODO VERSIONS CREDITS checkmech
	readme.gentoo_create_doc
}

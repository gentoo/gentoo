# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Window Maker dock application showing incoming mail"
HOMEPAGE="https://www.dockapps.net/wmail"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND=">=x11-libs/libdockapp-0.7:="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}.support-libdockapp-0.5.0.patch

	# make from parsing in maildir format faster, thanks
	# to Stanislav Kuchar
	eapply "${FILESDIR}"/${P}.maildir-parse-from.patch

	# fix LDFLAGS ordering, see bug #248620
	sed -i 's/$(LIBS) -o $@ $^/-o $@ $^ $(LIBS)/' "${S}/src/Makefile.in" || die

	# Honour Gentoo LDFLAGS, see bug #337407
	sed -i 's/-o $@ $^ $(LIBS)/$(LDFLAGS) -o $@ $^ $(LIBS)/' "${S}/src/Makefile.in" || die
	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i src/*.c || die
}

src_configure() {
	econf --enable-delt-xpms
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin src/wmail
	dodoc README wmailrc-sample
}

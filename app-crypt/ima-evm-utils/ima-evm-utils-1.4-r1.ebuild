# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Supporting tools for IMA and EVM"
HOMEPAGE="http://linux-ima.sourceforge.net"
SRC_URI="https://download.sourceforge.net/linux-ima/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test tpm"

RDEPEND="
	dev-libs/openssl:0=
	sys-apps/keyutils:=
	tpm? ( app-crypt/tpm2-tss:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	test? ( app-editors/vim-core )"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-1.4-configure-remove-automagic-TSS-dependencies.patch"
	"${FILESDIR}/${PN}-1.4-test-Rename-bash-variable-WORKDIR-to-MYWORKDIR.patch"
	"${FILESDIR}/${PN}-1.4-test-remove-boot_aggregate.patch"
)

src_prepare() {
	default

	sed -i '/^MANPAGE_DOCBOOK_XSL/s:/usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl:/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl:' Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_with tpm pcrtss)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

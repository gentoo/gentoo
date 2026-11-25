# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools git-r3

DESCRIPTION="Supporting tools for IMA and EVM"
HOMEPAGE="https://github.com/linux-integrity/ima-evm-utils"
EGIT_REPO_URI="https://github.com/linux-integrity/ima-evm-utils.git"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="debug test tpm"

RDEPEND="
	dev-libs/openssl:0=
	sys-apps/keyutils:=
	tpm? ( app-crypt/tpm2-tss:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	app-text/docbook-xsl-stylesheets
	dev-libs/libxml2
	dev-libs/libxslt
	test? (
		app-editors/vim-core
		sys-apps/attr
	)"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-1.4-configure-remove-automagic-TSS-dependencies.patch"
)

src_prepare() {
	default

	# tests/functions.sh cleanup does rm -rf "${WORKDIR}", which is
	# portage's WORKDIR in tests that never set it themselves
	sed -i 's/\bWORKDIR\b/MYWORKDIR/g' tests/functions.sh tests/sign_verify.test || die
	# needs a software TPM and ibmtss
	sed -i 's/ boot_aggregate\.test//' tests/Makefile.am || die

	eautoreconf
}

src_configure() {
	# only used for an uninstalled html page
	export ac_cv_prog_have_pandoc=no

	econf \
		$(use_enable debug) \
		$(use_with tpm pcrtss) \
		--disable-kerneltests \
		--with-xml-catalog="${BROOT}"/etc/xml/catalog
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

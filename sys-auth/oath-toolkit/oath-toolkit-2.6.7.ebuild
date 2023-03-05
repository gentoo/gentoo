# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pam

DESCRIPTION="Toolkit for using one-time password authentication with HOTP/TOTP algorithms"
HOMEPAGE="https://www.nongnu.org/oath-toolkit/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="pam pskc static-libs test"
REQUIRED_USE="test? ( pskc )"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/icu:=
	pam? ( sys-libs/pam )
	pskc? (
		dev-libs/libxml2
		dev-libs/xmlsec
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gtk-doc-am
	test? ( dev-libs/libxml2 )
"

PATCHES=(
	"${FILESDIR}"/${P}-new-xmlsec-tests.patch
)

QA_CONFIG_IMPL_DECL_SKIP=(
	MIN # glibc fp
)

src_configure() {
	local myeconfargs=(
		$(use_enable test xmltest)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		$(use_enable pskc)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# Without keep-going, it will bail out after the first testsuite failure,
	# skipping the other testsuites. as they are mostly independent, this sucks.
	emake --keep-going check

	# Avoid errant QA notice for no tests run on these
	rm -f libpskc/gtk-doc/test-suite.log liboath/gtk-doc/test-suite.log || die
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die

	if use pam; then
		newdoc pam_oath/README README.pam
	fi

	if use pskc; then
		doman pskctool/pskctool.1
	fi
}

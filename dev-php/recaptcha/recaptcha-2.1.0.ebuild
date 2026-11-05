# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="PHP client library for Google's reCAPTCHA service"
HOMEPAGE="https://github.com/google/recaptcha"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

# Tests require the unpackageable PHPUnit.
RDEPEND="dev-lang/php"

src_install() {
	insinto "/usr/share/php/${PN}"
	doins -r src/autoload.php src/ReCaptcha
	dodoc README.md
}

pkg_postinst() {
	elog "${PN} has been installed in /usr/share/php/${PN}/."
	elog "To use it in a script, require('${PN}/autoload.php'),"
	elog "and then use the ${PN} class normally. Most of the examples in"
	elog "the documentation should work without further modification."
}

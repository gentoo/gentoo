# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PHP captcha creator and validator library"
HOMEPAGE="https://www.phpcaptcha.org/"
SRC_URI="https://github.com/dapphp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/php[gd,truetype]
	virtual/httpd-php"

src_install() {
	# Grab all PHP files except the examples.
	set *.php
	local php_files=${@/*example*/}

	insinto /usr/share/php/${PN}
	doins -r ${php_files} *.{ttf,swf} audio backgrounds database images words

	dodoc README*
}

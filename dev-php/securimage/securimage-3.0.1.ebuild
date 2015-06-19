# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/securimage/securimage-3.0.1.ebuild,v 1.3 2012/04/27 03:35:28 binki Exp $

EAPI=4

DESCRIPTION="PHP captcha creator and validator library"
HOMEPAGE="http://phpcaptcha.org/"
SRC_URI="http://phpcaptcha.org/${P}.tar.gz
	ftp://mirror.ohnopub.net/mirror/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/php[gd,truetype]
	virtual/httpd-php"

S=${WORKDIR}/${PN}

src_install()
{
	# Grab all PHP files except the examples.
	set *.php
	local php_files=${@/*example*/}

	insinto /usr/share/php/${PN}
	doins -r ${php_files} *.{ttf,swf} audio backgrounds database images words

	dodoc README* *example*
}

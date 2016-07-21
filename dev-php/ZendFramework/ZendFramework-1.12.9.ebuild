# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_LIB_NAME="Zend"

inherit php-lib-r1

KEYWORDS="amd64 hppa ~ppc x86"

DESCRIPTION="Zend Framework is a high quality and open source framework for developing Web Applications"
HOMEPAGE="http://framework.zend.com/"
SRC_URI="!minimal? ( http://framework.zend.com/releases/${P}/${P}.tar.gz )
	minimal? ( http://framework.zend.com/releases/${P}/${P}-minimal.tar.gz )
	doc? (
		http://framework.zend.com/releases/${P}/${P}-apidoc.tar.gz
		http://framework.zend.com/releases/${P}/${P}-manual-en.tar.gz )"
LICENSE="BSD"
SLOT="0"
IUSE="cli doc examples minimal"

DEPEND="cli? ( dev-lang/php:*[simplexml,tokenizer] )"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	if use minimal ; then
		mv "${WORKDIR}/${P}-minimal" "${S}" || die
	fi
}

src_prepare() {
	if use minimal ; then
		if use doc ; then
			mv "${WORKDIR}/${P}/documentation" "${S}"
		fi
	fi
}

src_install() {
	if use cli ; then
		insinto /usr/bin
		doins bin/zf.php
		dobin bin/zf.sh
		dosym /usr/bin/zf.sh /usr/bin/zf
	fi
	php-lib-r1_src_install library/Zend $(cd library/Zend ; find . -type f -print)

	if ! use minimal ; then
		insinto /usr/share/php
		doins -r externals/dojo
		if use examples ; then
			insinto /usr/share/doc/${PF}
			doins -r demos
		fi
	fi

	dodoc README.md
	if use doc ; then
		dohtml -r documentation/*
	fi
}

pkg_postinst() {
	elog "For more info, please take a look at the manual at:"
	elog "http://framework.zend.com/manual"
	elog ""

	if use minimal; then
		elog "You have installed the minimal version of ZendFramework,"
		elog "so the Dojo toolkit, demos and tests have not been installed."
	else
		elog "You have installed the full version of ZendFramework, which"
		elog "includes the Dojo toolkit, demos and tests."
		elog "To install ZendFramework without these, enable the"
		elog "minimal USE flag."
	fi
}

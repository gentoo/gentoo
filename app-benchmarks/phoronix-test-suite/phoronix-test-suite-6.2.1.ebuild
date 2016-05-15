# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils bash-completion-r1

DESCRIPTION="Phoronix's comprehensive, cross-platform testing and benchmark suite"
HOMEPAGE="http://www.phoronix-test-suite.com"
SRC_URI="http://www.phoronix-test-suite.com/download.php?file=${P} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

# php 5.3 doesn't have pcre and reflection useflags anymore
RDEPEND="dev-lang/php[cli,curl,gd,json,posix,pcntl,truetype,zip]"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i -e "s,export PTS_DIR=\`pwd\`,export PTS_DIR=\"/usr/share/${PN}\"," \
		phoronix-test-suite
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}

	doman documentation/man-pages/phoronix-test-suite.1
	dodoc AUTHORS ChangeLog README.md
	dohtml -r documentation/
	doicon pts-core/static/images/phoronix-test-suite.png
	doicon pts-core/static/images/openbenchmarking.png
	domenu pts-core/static/phoronix-test-suite.desktop
	rm -f pts-core/static/phoronix-test-suite.desktop

	doins -r pts-core
	exeinto /usr/bin
	doexe phoronix-test-suite

	fperms a+x /usr/share/${PN}/pts-core/static/root-access.sh
	fperms a+x /usr/share/${PN}/pts-core/external-test-dependencies/scripts/install-gentoo-packages.sh

	newbashcomp pts-core/static/bash_completion ${PN}

	# Need to fix the cli-php config for downloading to work. Very naughty!
	local slots
	local slot
	if [[ "x${PHP_TARGETS}" == "x" ]] ; then
		ewarn
		ewarn "PHP_TARGETS seems empty, php.ini file can't be configured."
		ewarn "Make sure that PHP_TARGETS in /etc/make.conf is set."
		ewarn "phoronix-test-suite needs the 'allow_url_fopen' option set to \"On\""
		ewarn "for downloading to work properly."
		ewarn
	else
		for slot in ${PHP_TARGETS}; do
			slots+=" ${slot/-/.}"
		done
	fi

	for slot in ${slots}; do
		local PHP_INI_FILE="/etc/php/cli-${slot}/php.ini"
		if [[ -f ${PHP_INI_FILE} ]] ; then
			dodir $(dirname ${PHP_INI_FILE})
			cp ${PHP_INI_FILE} "${D}${PHP_INI_FILE}"
			sed -e 's|^allow_url_fopen .*|allow_url_fopen = On|g' -i "${D}${PHP_INI_FILE}"
		else
			if [[ "x$(eselect php show cli)" == "x${slot}" ]] ; then
				ewarn
				ewarn "${slot} hasn't a php.ini file."
				ewarn "phoronix-test-suite needs the 'allow_url_fopen' option set to \"On\""
				ewarn "for downloading to work properly."
				ewarn "Check that your PHP_INI_VERSION is set during ${slot} merge"
				ewarn
			else
				elog
				elog "${slot} hasn't a php.ini file."
				elog "phoronix-test-suite may need the 'allow_url_fopen' option set to \"On\""
				elog "for downloading to work properly if you switch to ${slot}"
				elog "Check that your PHP_INI_VERSION is set during ${slot} merge"
				elog
			fi
		fi
	done

	ewarn
	ewarn "If you upgrade from phoronix-test-suite-2*, you should reinstall all"
	ewarn "your tests because"
	ewarn "   \$HOME/.phoronix-test-suite/installed-tests/\$TEST_NAME/"
	ewarn "moves to"
	ewarn "   \$HOME/.phoronix-test-suite/installed-tests/pts/\$TEST_NAME-\$TEST_VERSION/"
	ewarn "in phoronix-test-suite-3* version. The \$TEST_VERSION can be find in"
	ewarn "pts-install.xml file."
	ewarn
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="A note taking perl program"
HOMEPAGE="https://www.daemon.de/NOTE"
SRC_URI="https://www.daemon.de/idisk/Apps/note/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="crypt dbm general mysql text"

DEPEND="
	dev-perl/Config-General
	dev-perl/TermReadKey
	dev-perl/Term-ReadLine-Perl
	dev-perl/YAML
	virtual/perl-Storable
	crypt? (
		dev-perl/Crypt-CBC
		dev-perl/Crypt-Blowfish
		dev-perl/Crypt-DES
	)
	mysql? ( dev-perl/DBD-mysql )
"
RDEPEND="${DEPEND}"

# extraneous README that gets installed into the perl module
PERL_RM_FILES=( NOTEDB/README )

src_prepare() {
	# Supressing file not needed
	local v
	for v in mysql text dbm general; do
		if ! use ${v}; then
			PERL_RM_FILES+=( NOTEDB/${v}.pm )
		fi
	done
	perl-module_src_prepare
}

src_install() {
	perl-module_src_install

	# Adding some basic utitily for testing note
	exeinto /usr/share/${PN}
	doexe bin/stresstest.sh

	# Adding some help for mysql backend driver
	if use mysql; then
		insinto /usr/share/${PN}/mysql
		exeinto /usr/share/${PN}/mysql
		doins mysql/{README,sql,permissions}
		doexe mysql/install.sh
	fi

	# Adding a sample configuration file
	insinto /etc
	doins config/noterc

	dodoc UPGRADE VERSION
}

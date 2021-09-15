# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOMHUKINS
DIST_VERSION="v${PV}"
inherit perl-module

DESCRIPTION="Get a domain name's public suffix via the Mozilla Public Suffix List"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Exporter
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	virtual/perl-IO
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-Test-Simple
		virtual/perl-File-Spec
	)
"

PATCHES=(
	"${FILESDIR}/${PV}-no-dynamic-update.patch"
)

src_test() {
	perl_rm_files t/author-* t/release-*
	perl-module_src_test
}

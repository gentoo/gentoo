# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin}"

DESCRIPTION="The reference implementation of Sass, written in Dart"
HOMEPAGE="https://sass-lang.com/dart-sass/"
SRC_URI="amd64? ( https://github.com/sass/dart-sass/releases/download/${PV}/${MY_PN}-${PV}-linux-x64.tar.gz )"
S="${WORKDIR}/${MY_PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

QA_PREBUILT="opt/dart-sass/src/dart"

RDEPEND="!dev-ruby/sass" # also installs /usr/bin/sass

src_install() {
	exeinto opt/dart-sass
	doexe sass
	exeinto opt/dart-sass/src
	doexe src/dart
	insinto opt/dart-sass/src
	doins src/sass.snapshot
	dosym ../../opt/dart-sass/sass usr/bin/sass || die "dosym failed"
}

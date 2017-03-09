# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=4

inherit autotools git-2

RESTRICT="test"

DESCRIPTION="OpenDylan language runtime environment"

HOMEPAGE="http://opendylan.org"
EGIT_HAS_SUBMODULES="1"
EGIT_REPO_URI="https://github.com/dylan-lang/opendylan.git"

LICENSE="Opendylan"
SLOT="0"

IUSE=""

DEPEND="dev-libs/boehm-gc[threads]
	dev-lang/perl
	dev-perl/XML-Parser
	|| ( dev-lang/opendylan-bin dev-lang/opendylan )"
RDEPEND="${DEPEND}"

src_prepare() {
	mkdir -p build-aux
	elibtoolize && eaclocal || die "Fail"
	automake --foreign --add-missing # this one dies wrongfully
	eautoconf || die "Fail"

	# quick hack
	sed -i -e 's:/usr/local:/usr:' admin/builds/fdmake.pl || die
}

src_configure() {
	if has_version =dev-lang/opendylan-bin-2014.1; then
		PATH=/opt/opendylan-2014.1/bin/:$PATH
	elif has_version =dev-lang/opendylan-bin-2013.2; then
		PATH=/opt/opendylan-2013.2/bin/:$PATH
	elif has_version =dev-lang/opendylan-bin-2013.1; then
		PATH=/opt/opendylan-2013.1/bin/:$PATH
	elif has_version =dev-lang/opendylan-bin-2012.1; then
		PATH=/opt/opendylan-2012.1/bin/:$PATH
	elif has_version =dev-lang/opendylan-bin-2011.1; then
		PATH=/opt/opendylan-2011.1/bin/:$PATH
	else
		PATH=/opt/opendylan/bin/:$PATH
	fi
	econf --prefix=/opt/opendylan || die
}

src_compile() {
	ulimit -s 32000 # this is naughty build system
	emake -j1 || die
}

src_install() {
	ulimit -s 32000 # this is naughty build system
	# because of Makefile weirdness it rebuilds quite a bit here
	# upstream has been notified
	emake -j1 DESTDIR="${D}" install
	mkdir -p "${D}/etc/env.d/opendylan/"
	echo "export PATH=/opt/opendylan/bin:\$PATH" > "${D}/etc/env.d/opendylan/opendylan" || die "Failed to add env settings"
}

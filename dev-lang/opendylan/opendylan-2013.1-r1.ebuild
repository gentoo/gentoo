# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools

DESCRIPTION="OpenDylan language runtime environment"
HOMEPAGE="http://opendylan.org"
SRC_URI="http://opendylan.org/downloads/${PN}/${PV}/${P}-sources.tar.bz2"

LICENSE="Opendylan"
SLOT="0"
# not tested on x86
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

# the boehm-gc check is "wrong" and reported upstream
# but for now static-libs useflag is needed
DEPEND="app-arch/unzip
	dev-libs/boehm-gc
	dev-lang/perl
	dev-perl/XML-Parser
	|| ( dev-lang/opendylan-bin dev-lang/opendylan )
	x86? ( <dev-libs/mps-1.108 )"
RDEPEND="${DEPEND}"

# on x86 there's a dependency on mps, but the build system is a bit ... hmm ...
# let's give it more of a chance to survive then
NAUGHTY_FILES=(
	sources/lib/run-time/collector.c.malloc
	sources/lib/run-time/collector.c
	sources/lib/run-time/pentium-win32/buffalo-collector.c
	sources/lib/run-time/pentium-win32/heap-stats.c
	sources/lib/run-time/heap-utils.h
	)

NAUGHTY_HEADERS=(
	mps.h
	mpscmv.h
	mpscamc.h
	mpsavm.h
	)

S="${WORKDIR}/${PN}"

src_prepare() {
	mkdir -p build-aux
	elibtoolize && eaclocal || die "Fail"
	automake --foreign --add-missing # this one dies wrongfully
	eautoconf || die "Fail"
	# mps headers, included wrong
	if use x86; then
	for i in ${NAUGHTY_FILES[@]}; do
		for header in ${NAUGHTY_HEADERS[@]}; do
			sed -i -e "s:\"${header}\":<${header}>:" $i
		done
	done
	fi
}

src_configure() {
	if has_version =dev-lang/opendylan-bin-2013.1; then
		PATH=/opt/opendylan-2013.1/bin/:$PATH
	elif has_version =dev-lang/opendylan-bin-2012.1; then
		PATH=/opt/opendylan-2012.1/bin/:$PATH
	elif has_version =dev-lang/opendylan-bin-2011.1; then
		PATH=/opt/opendylan-2011.1/bin/:$PATH
	else
		PATH=/opt/opendylan/bin:$PATH
	fi
	if use amd64; then
		econf --prefix=/opt/opendylan || die
	else
		econf --prefix=/opt/opendylan --with-mps=/usr/include/mps/ || die
	fi
	if use x86; then
	# Includedir, pointing at something wrong
	sed -i -e 's:-I$(MPS)/code:-I$(MPS):'  sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps path"
	sed -i -e 's~(cd $(MPS)/code; make -f lii4gc.gmk mmdw.a)~:;~' sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps building"
	sed -i -e 's~(cd $(MPS)/code; make -f lii4gc.gmk mpsplan.a)~:;~' sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps building"
	sed -i -e 's~$(MPS_LIB)/mpsplan.a~/usr/lib/mpsplan.a~' sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps clone"
	sed -i -e 's~$(MPS_LIB)/mmdw.a~/usr/lib/mmdw.a~' sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps clone"
	fi
}

src_compile() {
	ulimit -s 32000 # this is naughty build system
	emake -j1 3-stage-bootstrap || die
}

src_install() {
	ulimit -s 32000 # this is naughty build system
	# because of Makefile weirdness it rebuilds quite a bit here
	# upstream has been notified
	emake -j1 DESTDIR="${D}" install
	mkdir -p "${D}/etc/env.d/opendylan/"
	echo "export PATH=/opt/opendylan/bin:\$PATH" > "${D}/etc/env.d/opendylan/99-opendylan" || die "Failed to add env settings"
}

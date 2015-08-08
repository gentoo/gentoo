# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit multilib toolchain-funcs base flag-o-matic

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="https://chromium.googlesource.com/webm/${PN}.git"
elif [[ ${PV} == *pre* ]]; then
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
else
	SRC_URI="http://webm.googlecode.com/files/${PN}-v${PV}.tar.bz2"
	KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}-v${PV}"
fi

DESCRIPTION="WebM VP8 Codec SDK"
HOMEPAGE="http://www.webmproject.org"

LICENSE="BSD"
SLOT="0"
IUSE="altivec debug doc cpu_flags_x86_mmx postproc cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 static-libs +threads"

RDEPEND=""
DEPEND="amd64? ( dev-lang/yasm )
	x86? ( dev-lang/yasm )
	x86-fbsd? ( dev-lang/yasm )
	doc? (
		app-doc/doxygen
		dev-lang/php
	)
"

REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
"

PATCHES=(
	"${FILESDIR}/${P}-chost.patch"
	"${FILESDIR}/${P}-generic-gnu-shared.patch"
	"${FILESDIR}/${P}-arm.patch"
	"${FILESDIR}/${P}-x32.patch"
)

src_configure() {
	replace-flags -ggdb3 -g #402825

	unset CODECS #357487

	# let the build system decide which AS to use (it honours $AS but
	# then feeds it with yasm flags without checking...) #345161
	local a
	tc-export AS
	for a in {amd64,x86}{,-{fbsd,linux}} ; do
		use ${a} && unset AS
	done

	# build verbose by default
	MAKEOPTS="${MAKEOPTS} verbose=yes"

	# http://bugs.gentoo.org/show_bug.cgi?id=384585
	# https://bugs.gentoo.org/show_bug.cgi?id=465988
	# copied from php-pear-r1.eclass
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/
	addpredict /var/lib/net-snmp/mib_indexes
	addpredict /session_mm_cli0.sem

	# Build with correct toolchain.
	tc-export CC AR NM
	# Link with gcc by default, the build system should override this if needed.
	export LD="${CC}"

	set -- \
	./configure \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--enable-pic \
		--enable-vp8 \
		--enable-shared \
		--extra-cflags="${CFLAGS}" \
		$(use_enable altivec) \
		$(use_enable debug debug-libs) \
		$(use_enable debug) \
		$(use_enable doc install-docs) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable postproc) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse4_1) \
		$(use_enable cpu_flags_x86_ssse3 ssse3) \
		$(use_enable static-libs static ) \
		$(use_enable threads multithread)
	echo "$@"
	"$@" || die
}

src_install() {
	# Override base.eclass's src_install.
	default
}

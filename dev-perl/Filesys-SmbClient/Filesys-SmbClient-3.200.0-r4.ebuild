# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ALIAN
DIST_VERSION=3.2
inherit perl-module autotools toolchain-funcs

DESCRIPTION="Provide Perl API for libsmbclient.so"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=net-fs/samba-4.2[client]"
DEPEND=">=net-fs/samba-4.2[client]"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
	test? (
		virtual/perl-Test-Simple
	)
"

PATCHES=(
	"${FILESDIR}/${P}-close_fn.patch"
	"${FILESDIR}/${PN}-3.2-no-magic-libdir.patch"
)

src_prepare() {
	perl-module_src_prepare
	cp -vf configure.in configure.ac || die "Can't copy configure.in"
	perl_rm_files configure.in
	eautoreconf
}
src_configure() {
	GENTOO_INC_SMBCLIENT="$( $(tc-getPKG_CONFIG) --variable=includedir smbclient )" \
		GENTOO_LIB_SMBCLIENT="$( $(tc-getPKG_CONFIG) --variable=libdir smbclient )" \
		perl-module_src_configure
}
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
src_test() {
	local MODULES=(
		"Filesys::SmbClient ${DIST_VERSION}"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "$dep" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	# standard tests are not designed to work on a non-developer system.
}

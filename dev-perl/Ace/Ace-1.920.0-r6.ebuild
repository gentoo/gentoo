# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_NAME=AcePerl
DIST_AUTHOR=LDS
DIST_VERSION=1.92
DIST_EXAMPLES=("examples/*")
inherit perl-module toolchain-funcs

DESCRIPTION="Object-Oriented Access to ACEDB Databases"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test ) mirror"
# License note: Indemnification and Attribution-if-Used bug #718936
RDEPEND="
	virtual/perl-Digest-MD5
	dev-perl/Cache-Cache
	dev-perl/GD
"
DEPS_TIRPC="
	net-libs/libtirpc
	net-libs/rpcsvc-proto
"
DEPEND="
	elibc_glibc? ( ${DEPS_TIRPC} )
	elibc_musl? ( ${DEPS_TIRPC} )
	elibc_uclibc? ( ${DEPS_TIRPC} )
"
BDEPEND="
	${RDEPEND}
	${DEPEND}
"
mydoc="DISCLAIMER.txt"
src_prepare() {
	eapply "${FILESDIR}/${PN}-1.92-rpcxs.patch"
	eapply "${FILESDIR}/${PN}-1.92-gcc-nonvoid.patch"
	eapply "${FILESDIR}/${PN}-1.92-toolchain.patch"
	cp "${FILESDIR}/${PN}-1.92-DARWIN_DEF" "${S}/acelib/wmake/DARWIN_DEF" || die "can't copy DARWIN_DEF"
	if use elibc_glibc || use elibc_musl || use elibc_uclibc ; then
		export LIBS="-ltirpc"
	fi
	perl-module_src_prepare
}
src_compile() {
	mymake=(
		"AR=$(tc-getAR)"
		"TARGET_CC=$(tc-getCC)"
		"TARGET_LD=$(tc-getLD)"
		"RANLIB=$(tc-getRANLIB)"
		"OPTIMIZE=${CFLAGS}"
		# Parallel compile breaks :(
		"-j1"
	)
	if use elibc_glibc || use elibc_musl || use elibc_uclibc ; then
		mymake+=( "LIBS=-ltirpc -lm" )
		mymake+=( "USEROPTS=-I/usr/include/tirpc -fPIC" )
	fi
	perl-module_src_compile
}

src_test() {
	local MODULES=(
		"Ace ${DIST_VERSION}"
		"Ace::Freesubs 1.00"
		"Ace::Graphics::Fk" # NO VERSION
		"Ace::Graphics::Glyph"
		"Ace::Graphics::Glyph::anchored_arrow"
		"Ace::Graphics::Glyph::arrow"
		"Ace::Graphics::Glyph::box"
		"Ace::Graphics::Glyph::crossbox"
		"Ace::Graphics::Glyph::dot"
		"Ace::Graphics::Glyph::ex"
		"Ace::Graphics::Glyph::graded_segments"
		"Ace::Graphics::Glyph::group"
		"Ace::Graphics::Glyph::line"
		"Ace::Graphics::Glyph::primers"
		"Ace::Graphics::Glyph::segments"
		"Ace::Graphics::Glyph::span"
		"Ace::Graphics::Glyph::toomany"
		"Ace::Graphics::Glyph::transcript"
		"Ace::Graphics::Glyph::triangle"
		"Ace::Graphics::GlyphFactory"
		"Ace::Graphics::Panel"
		"Ace::Graphics::Track"
		"Ace::Iterator 1.51"
		"Ace::Local 1.05"
		"Ace::Model 1.51"
		"Ace::Object 1.66"
		"Ace::Object::Wormbase"
		"Ace::RPC 1.00"
		"Ace::Sequence 1.51"
		"Ace::Sequence::Feature"
		"Ace::Sequence::FeatureList"
		"Ace::Sequence::GappedAlignment 1.20"
		"Ace::Sequence::Gene"
		"Ace::Sequence::Homol"
		"Ace::Sequence::Multi"
		"Ace::Sequence::Transcript"
		"Ace::SocketServer 1.01"
		"GFF::Filehandle"
# Need Ace::Browser
# 		"Ace::Browser::AceSubs ${DIST_VERSION}"
#		"Ace::Browser::GeneSubs ${DIST_VERSION}"
#		"Ace::Browser::SearchSubs ${DIST_VERSION}"
#		"Ace::Browser::SiteDefs ${DIST_VERSION}"
#		"Ace::Browser::TreeSubs ${DIST_VERSION}"
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
	if ! has "network" "${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}"; then
		ewarn "This package needs network access to run its full test suite"
		ewarn "For details, see:"
		ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-nodes/dev-perl/Ace"
		ewarn ""
	else
		perl-module_src_test
	fi
}

pkg_postinst() {
	ewarn "This package requests that publications that made use of this software"
	ewarn "in the process of their research attribute it."
	ewarn ""
	ewarn "This package's licensing terms also include indemnification clauses"
	ewarn "which may apply to you, and are currently under decision in"
	ewarn " Bug: https://bugs.gentoo.org/718936"
	ewarn ""
	ewarn "Please read ${EROOT}/usr/share/doc/${PF}/DISCLAIMER.*"
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# This appears it should really be entitled Audio-CD
# There are * QA Notice: errors on building however the HOMEPAGE gives no source repo in which to file
# prob. not worth the trouble for this little script.

DIST_EXAMPLES=("eg/*")
inherit perl-module

MY_P=Audio-CD-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl Module needed for app-cdr/disc-cover"
HOMEPAGE="http://www.vanhemert.co.uk/disc-cover.html"
SRC_URI="http://www.vanhemert.co.uk/files/${MY_P}.tar.gz"

IUSE=""
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"

RDEPEND=">=dev-perl/URI-1.10
	>=dev-perl/HTML-Parser-3.15
	>=virtual/perl-MIME-Base64-2.12
	>=virtual/perl-Digest-MD5-2.12
	>=virtual/perl-libnet-1.0703-r1
	>=dev-perl/libwww-perl-5.50
	>=media-libs/libcdaudio-0.99.6"
DEPEND="${RDEPEND}"

src_test() {
	local MODULES=(
		"Audio::CD ${PV}"
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
	perl-module_src_test
}

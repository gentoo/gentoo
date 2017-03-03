# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils versionator

MY_PV="$(replace_version_separator 2 -)"

DESCRIPTION="Secure file removal utility"
HOMEPAGE="http://www.jetico.com/"
SRC_URI="https://www.jetico.com/linux/BCWipe-${MY_PV}.tar.gz
	doc? ( http://www.jetico.com/linux/BCWipe.doc.tgz )"

LICENSE="bestcrypt"
SLOT="0"
IUSE="doc"
KEYWORDS="amd64 ~arm ~ppc ~x86"

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-1.9.7-fix_warnings.patch"
	"${FILESDIR}/${PN}-1.9.8-fix-flags.patch"
)

S="${WORKDIR}/${PN}-${MY_PV}"

src_test() {
	echo "abc123" >> testfile
	./bcwipe -f testfile || die "bcwipe test failed"
	[[ -f testfile ]] && die "test file still exists. bcwipe should have deleted it"
}

src_install() {
	default

	use doc && dodoc -r ../bcwipe-help
}

pkg_postinst() {
	ewarn "The BestCrypt drivers are not free - Please purchace a license from "
	ewarn "http://www.jetico.com/"
	ewarn "full details /usr/share/doc/${PF}/bcwipe-help/wu_licen.htm"
}

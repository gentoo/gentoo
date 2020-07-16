# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools vcs-snapshot

GIT_COMMIT="7ab537a4f45e34984cbeb9cf1b1af543a75a3dc0"

DESCRIPTION="Library to interact with PS Vita's USB MTP protocol"
HOMEPAGE="https://github.com/codestation/vitamtp"
SRC_URI="https://github.com/codestation/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	virtual/libusb:1
	dev-libs/libxml2
"
RDEPEND="${DEPEND}"

src_prepare() {
	rm ChangeLog || die "Failed to rm changelog" # Triggers QA warn (symlink to nowhere)

	sed -r \
		-e 's@vitamtp@usb@' \
		-i debian/libvitamtp5.udev
	# ^ ease console management for users
	# (we don't really need extra group for this)

	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
	insinto /lib/udev/rules.d
	newins debian/libvitamtp5.udev 10-vitamtp.rules
}

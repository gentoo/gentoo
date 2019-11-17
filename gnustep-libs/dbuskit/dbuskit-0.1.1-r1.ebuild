# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnustep-2

DESCRIPTION="framework that interfaces Objective-C applications with the D-Bus IPC service"
HOMEPAGE="https://github.com/gnustep/libs-dbuskit"
SRC_URI="https://github.com/gnustep/libs-dbuskit/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=sys-apps/dbus-1.2.1"
RDEPEND="${DEPEND}"

PATCHES=( ${FILESDIR}/${P}-remove_gc.patch )

S=${WORKDIR}/libs-${P}

src_prepare() {
	default

	if ! use doc; then
		# Remove doc target
		sed -i -e "/SUBPROJECTS/s/Documentation//" GNUmakefile \
			|| die "doc sed failed"
	fi

	# Bug 410697
	sed -e "s#ObjectiveC2/runtime.h#ObjectiveC2/objc/runtime.h#" \
		-i configure.ac || die "ObjectiveC2 runtime sed failed"

	eautoreconf
}

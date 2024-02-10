# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit unpacker

MY_PN="${PN%-bin}"

DESCRIPTION="Hassle-free time tracking for JIRA self-hosted and OnDemand"
HOMEPAGE="https://worklogassistant.com"
SRC_URI="https://worklogassistant.com/downloads/${MY_PN}-v2_${PV}_amd64.deb"

LICENSE="worklog-assistant"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="fetch bindist strip"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}/${P}-fix-desktop.patch"
)

src_prepare() {
	default

	rm -r etc/ || die
	rm _gpgbuilder || die
}

src_install() {
	mv * "${ED}" || die

	dosym "/opt/Worklog Assistant/bin/Worklog Assistant" /opt/bin/WorklogAssistant
}

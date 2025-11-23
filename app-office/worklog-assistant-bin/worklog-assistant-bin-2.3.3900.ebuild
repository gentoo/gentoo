# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Hassle-free time tracking for JIRA self-hosted and OnDemand"
HOMEPAGE="https://worklogassistant.com"
SRC_URI="https://worklogassistant.com/downloads/${PN%-bin}-v2_${PV}_amd64.deb"
S=${WORKDIR}

LICENSE="worklog-assistant"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="fetch bindist strip"

QA_PREBUILT="opt/Worklog Assistant/*"

src_prepare() {
	default

	rm -r etc/ || die
}

src_install() {
	mv * "${ED}" || die

	dosym -r "/opt/Worklog Assistant/bin/Worklog Assistant" /opt/bin/WorklogAssistant
}

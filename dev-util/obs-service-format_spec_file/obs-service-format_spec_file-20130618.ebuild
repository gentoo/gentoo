# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ADDITIONAL_FILES="
	licenses_changes.txt
	patch_license
	prepare_spec
"
inherit obs-service

IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-util/obs-service-source_validator
"

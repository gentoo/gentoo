# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Metapackage to pull all open build service services"
HOMEPAGE="http://openbuildservice.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-util/obs-service-cpanspec
	dev-util/obs-service-download_files
	dev-util/obs-service-download_src_package
	dev-util/obs-service-download_url
	dev-util/obs-service-extract_file
	dev-util/obs-service-format_spec_file
	dev-util/obs-service-generator_driver_update_disk
	dev-util/obs-service-git_tarballs
	dev-util/obs-service-github_tarballs
	dev-util/obs-service-rearchive
	dev-util/obs-service-recompress
	dev-util/obs-service-set_version
	dev-util/obs-service-source_validator
	dev-util/obs-service-update_source
	dev-util/obs-service-verify_file
"

pkg_postinst() {
	if ! has_version dev-util/obs-service-tar_scm ; then
		elog "You should consider installing also following package"
		elog "if you plan to work with SCM packages:"
		elog "    dev-util/obs-service-tar_scm"
	fi
}

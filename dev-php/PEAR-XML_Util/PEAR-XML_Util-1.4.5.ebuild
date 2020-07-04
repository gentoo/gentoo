# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="XML utility class"
HOMEPAGE="https://pear.php.net/package/XML_Util"
SRC_URI="https://pear.php.net/get/${MY_P}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="examples"

# PCRE is needed for a few calls to preg_replace and preg_match.
RDEPEND="dev-lang/php:*[pcre(+)]"
PDEPEND="dev-php/PEAR-PEAR"
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r XML

	use examples && dodoc -r examples
	insinto /usr/share/php/.packagexml
	if [[ -f "${WORKDIR}/package.xml" ]] ; then
		newins "${WORKDIR}/package.xml" "${MY_P}.xml"
	fi
}

pkg_postinst() {
	# Register the package from the package{,2}.xml file
	# It is not critical to complete so only warn on failure
	# Can only be done on reinstall/upgrade as this is a PEAR dep
	if [[ -n "${REPLACING_VERSIONS}" && -f "${EROOT}/usr/share/php/.packagexml/${MY_P}.xml" ]] ; then
		"${EROOT}/usr/bin/peardev" install -nrO --force \
			"${EROOT}/usr/share/php/.packagexml/${MY_P}.xml" 2> /dev/null \
			|| ewarn "Failed to insert package into local PEAR database"
	fi
}

pkg_postrm() {
	# Uninstall known dependency
	[[ -n "${REPLACING_VERSIONS}" ]] && \
	"${EROOT}/usr/bin/peardev" uninstall -nrO "pear.php.net/XML_Util"
}

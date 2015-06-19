# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mod_survey/mod_survey-3.2.5.ebuild,v 1.4 2015/06/13 17:20:49 dilfridge Exp $

inherit depend.apache webapp

WEBAPP_MANUAL_SLOT="yes"
SLOT="0"

MY_PN=${PN/_/}

DESCRIPTION="XML-defined web questionnaires as a plug-in module using Apache"
HOMEPAGE="http://www.modsurvey.org"
SRC_URI="http://www.modsurvey.org/download/tarballs/${MY_PN}-${PV}.tgz
	doc? ( http://www.modsurvey.org/download/tarballs/${MY_PN}-docs-${PV}.tgz )"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc mysql nls postgres"

LANGS="en de fr it sv"
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done

DEPEND=">=dev-lang/perl-5.6.1"
RDEPEND="${DEPEND}
	>=www-apache/mod_perl-1.99
	postgres? ( >=dev-perl/DBI-1.38 dev-perl/DBD-Pg )
	mysql? ( >=dev-perl/DBI-1.38 dev-perl/DBD-mysql )
	>=dev-perl/CGI-3.0.0"

S="${WORKDIR}"/${MY_PN}-${PV}

pkg_setup() {
	webapp_pkg_setup
	has_apache

	if use nls; then
		for i in ${LINGUAS}; do
			if has linguas_${i} ${IUSE}; then
				if use linguas_${i}; then
					locallang="${i}"
					ewarn "${i} from the LINGUAS variable has been set as the"
					ewarn "default language. This can be overriden on a"
					ewarn "per-survey basis, or changed in"
					ewarn "${APACHE_MODULES_CONFDIR}/98_${PN}.conf"
					ewarn
					break
				fi
			else
				einfo "LINGUAS=${i} is not supported by ${P}"
				shift
			fi
		done
	fi

	if [[ -z ${locallang} ]]; then
		[[ -n "${LINGUAS}" ]] && ewarn "None of ${LINGUAS} supported."
		use nls && ewarn "Will use English as default language."
		locallang="en"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s|\$lang = \"en\"|\$lang = \"${locallang}\"|" \
		-e "s|/usr/local/mod_survey/|${D}/usr/lib/mod_survey/|g" \
		installer.pl

	rm -f docs/LICENSE.txt
	use doc && unpack ${MY_PN}-docs-${PV}.tgz
}

src_install() {
	webapp_src_preinst

	dodir /usr/lib/mod_survey
	dodir /var/lib/mod_survey

	dodoc README.txt docs/*
	rm -rf README.txt docs/

	insinto /usr/share/doc/${PF}
	doins -r webroot/examples*
	rm -rf webroot/examples*

	perl installer.pl < /dev/null > /dev/null 2>&1
	rm -rf "${D}"/usr/lib/mod_survey/{survey.conf,data,docs,webroot}

	insinto "${MY_HTDOCSDIR}"
	doins -r webroot/{main.css,system}

	insinto "${APACHE_MODULES_CONFDIR}"
	doins "${FILESDIR}"/98_${PN}.conf

	fowners apache:apache /var/lib/mod_survey

	webapp_src_install
}

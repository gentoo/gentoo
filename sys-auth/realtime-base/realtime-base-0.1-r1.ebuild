# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sets up realtime scheduling"
HOMEPAGE="https://jackaudio.org/faq/linux_rt_config.html"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="acct-group/realtime
	sys-libs/pam"

S="${WORKDIR}"

limitsdfile=40-${PN}.conf
rtgroup=realtime

src_compile() {
	einfo "Generating ${limitsdfile}"
	cat > ${limitsdfile} <<- EOF || die
		# Start of ${limitsdfile} from ${P}

		@${rtgroup}	-	rtprio	99
		@${rtgroup}	-	memlock	unlimited

		# End of ${limitsdfile} from ${P}
	EOF
}

src_install() {
	insinto /etc/security/limits.d/
	doins ${limitsdfile}
}

pkg_postinst() {
	elog "We have added realtime scheduling privileges for users in the ${rtgroup} group."
	elog "Please make sure users needing such privileges are in that group."
}

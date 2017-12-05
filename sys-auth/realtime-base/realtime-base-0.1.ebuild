# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3

inherit user

DESCRIPTION="Sets up realtime scheduling"
HOMEPAGE="http://jackaudio.org/faq/linux_rt_config.html"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sh sparc x86 ~amd64-fbsd"
IUSE=""

DEPEND=""
RDEPEND="virtual/pam"

limitsdfile=40-${PN}.conf
rtgroup=realtime

S=${WORKDIR}

pkg_setup() {
	enewgroup ${rtgroup}
}

print_limitsdfile() {
	printf "# Start of ${limitsdfile} from ${P}\n\n"
	printf "@${rtgroup}\t-\trtprio\t99\n"
	printf "@${rtgroup}\t-\tmemlock\tunlimited\n"
	printf "\n# End of ${limitsdfile} from ${P}\n"
}

src_compile() {
	einfo "Generating ${limitsdfile}"
	print_limitsdfile > "${S}/${limitsdfile}"
}

src_install() {
	insinto /etc/security/limits.d/
	doins "${S}/${limitsdfile}" || die
}

pkg_postinst() {
	elog "We have added realtime scheduling privileges for users in the ${rtgroup} group."
	elog "Please make sure users needing such privileges are in that group."
}

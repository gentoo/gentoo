# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils readme.gentoo user

DESCRIPTION="Tracking software for asset recovery"
HOMEPAGE="http://preyproject.com/"
SRC_URI="http://preyproject.com/releases/${PV}/${P}-linux.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk userpriv"

LINGUAS="en it sv es"
for x in ${LINGUAS}; do
	IUSE="${IUSE} linguas_${x}"
done

MODULES="+alarm +alert +geo lock +network secure +session webcam"
IUSE="${IUSE} ${MODULES}"

DEPEND=""
#TODO: some of these deps may be dependent on USE
RDEPEND="${DEPEND}
	app-shells/bash
	virtual/cron
	|| ( net-misc/curl net-misc/wget )
	dev-perl/IO-Socket-SSL
	dev-perl/Net-SSLeay
	sys-apps/net-tools
	alarm? ( media-sound/mpg123
			 media-sound/pulseaudio
		   )
	alert? ( || ( ( gnome-extra/zenity ) ( kde-apps/kdialog ) ) )
	gtk? ( dev-python/pygtk )
	lock? ( dev-python/pygtk )
	network? ( net-analyzer/traceroute )
	session? ( sys-apps/iproute2
			   || ( media-gfx/scrot media-gfx/imagemagick )
			 )
	webcam? ( || ( ( media-video/mplayer[encode,jpeg,v4l] ) ( media-tv/xawtv ) ) )"

S=${WORKDIR}/${PN}

pkg_setup() {
	if use userpriv; then
		enewgroup ${PN}
	fi
	if use gtk; then
		ewarn "You have the 'gtk' useflag enabled"
		ewarn "This means that the ${PN} configuration"
		ewarn "will be accessible via a graphical user"
		ewarn "interface. This may allow the thief to alter"
		ewarn "or disable the ${PN} functionality"
	fi
}

src_prepare() {
	DISABLE_AUTOFORMATTING="yes"
	use userpriv && has_version "${CATEGORY}/${PN}:${SLOT}[-userpriv]" && FORCE_PRINT_ELOG="yes"
	! use userpriv && has_version "${CATEGORY}/${PN}:${SLOT}[userpriv]" && FORCE_PRINT_ELOG="yes"

	DOC_CONTENTS="--Configuration--
Make sure you follow the next steps before running prey for the
first time.
"

	if use userpriv; then
		DOC_CONTENTS+="- Add your user to ${PN} group using:
# gpasswd -a <your_user> ${PN}"
	else
		DOC_CONTENTS+="You don't seem to have 'userpriv' enabled so
${PN} configuration is only accessible as root"
	fi

	DOC_CONTENTS+="
- Create an account on http://preyproject.com/
- Modify the core and module configuration in /etc/prey
- Uncomment the line in /etc/cron.d/prey.cron"

	# remove system module since it depends on hal and we don't
	# have hal in portage anymore
	rm -rf "${S}"/modules/system || die

	epatch "${FILESDIR}"/${P}-cron-functions.patch \
		"${FILESDIR}"/${P}-gtk-ui.patch \
		"${FILESDIR}"/${PN}-0.5.3-mplayer-support.patch
	sed -i -e 's,readonly base_path=`dirname "$0"`,readonly \
		base_path="/usr/share/prey",' \
		"${S}"/prey.sh || die
	# Fix base path. Bug #438728
	sed -i -e "/readonly/s:base_path=.*:base_path=/usr/share/${PN}:" \
		prey.sh || die
}

src_install() {
	# Remove config app if -gtk
	if use gtk; then
		# fix the path
		doicon "${S}"/pixmaps/${PN}.png
		newbin "${S}"/platform/linux/${PN}-config.py ${PN}-config
		make_desktop_entry ${PN}-config "Prey Configuration" ${PN} \
			"System;Monitor"
	else
		rm -f "${S}"/platform/linux/prey-config.py || die
	fi

	# clear out unneeded language files
	for lang in ${LINGUAS}; do
		use "linguas_${lang}" || rm -f lang/${lang} modules/*/lang/${lang}
	done

	# Core files
	insinto /usr/share/prey
	doins -r "${S}"/core "${S}"/lang "${S}"/pixmaps "${S}"/platform "${S}"/version

	# Main script
	newbin ${PN}.sh ${PN}

	# Put the configuration file into /etc, strict perms, symlink
	insinto /etc/prey
	newins config ${PN}.conf
	# some scripts require /usr/share/prey/config file to be present
	# so symlink it to prey.conf
	dosym /etc/${PN}/${PN}.conf /usr/share/${PN}/config
	use userpriv && { fowners root:${PN} /etc/prey ; }
	fperms 770 /etc/prey
	use userpriv && { fowners root:${PN} /etc/prey/prey.conf ; }
	fperms 660 /etc/prey/prey.conf

	# Add cron.d script
	insinto /etc/cron.d
	doins "${FILESDIR}/prey.cron"
	use userpriv && { fowners root:${PN} /etc/cron.d/prey.cron ; }
	fperms 660 /etc/cron.d/prey.cron

	dodoc README

	# modules
	cd "${S}"/modules
	for mod in *
	do
		use ${mod} || continue

		# move config, if present, to /etc/prey
		if [ -f $mod/config ]
		then
			insinto "/etc/prey"
			newins "$mod/config" "mod-$mod.conf"
			use userpriv && { fowners root:${PN} "/etc/${PN}/mod-$mod.conf" ; }
			fperms 660 "/etc/${PN}/mod-$mod.conf"
			# Rest of the module in its expected location
			insinto /usr/share/prey/modules
			doins -r "$mod"
			if [[ $mod == "lock" ]]; then
				fperms 555 \
					"/usr/share/${PN}/modules/lock/platform/linux/${PN}-lock"
			fi
		fi
	done

	readme.gentoo_create_doc
}

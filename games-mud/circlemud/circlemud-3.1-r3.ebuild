# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A multi-user dungeon game system server"
HOMEPAGE="https://www.circlemud.org/"
SRC_URI="https://www.circlemud.org/pub/CircleMUD/3.x/circle-${PV}.tar.bz2"
S="${WORKDIR}"/circle-${PV}

LICENSE="circlemud"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/openssl:0=
	virtual/libcrypt:="
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"

src_prepare() {
	default

	cd src || die

	touch .accepted || die

	sed -i \
		-e 's:^read.*::' licheck || die

	# make circlemud fit into Gentoo nicely
	sed -i \
		-e "s:\"lib\":\"${EPREFIX}/var/lib/${PN}\":g" \
		-e "s:\(LOGNAME = \)NULL:\1\"${EPREFIX}/var/log/${PN}.log\":g" \
		config.c || die

	# Now let's rename binaries (too many are very generic)
	sed -i \
		-e "s:\.\./bin/autowiz:${PN}-autowiz:" limits.c || die

	tc-export CC
	eapply "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake -C src
}

src_install() {
	local bin

	for bin in autowiz delobjs listrent mudpasswd play2to3 purgeplay \
	           shopconv showplay sign split wld2html ; do
		newbin bin/${bin} ${PN}-${bin}
		fowners :gamestat /usr/bin/${PN}-${bin}
		fperms g+s /usr/bin/${PN}-${bin}
	done

	dobin bin/circle
	fowners :gamestat /usr/bin/circle
	fperms g+s /usr/bin/circle

	insinto /var/lib/${PN}
	doins -r lib/*

	insinto /etc/${PN}
	doins lib/etc/*
	fperms 770 /etc/circlemud
	fperms 660 /etc/circlemud/*
	fowners :gamestat /usr/bin/circle

	dodir /var/log
	touch "${ED}"/var/log/circlemud.log || die
	fperms -R 660 /var/log/${PN}.log
	fowners :gamestat /var/log/circlemud.log

	# Tidy up some of the installed files which we've shoved into other locations
	rm -r "${ED}"/var/lib/circlemud/etc/ || die
	dosym ../../../etc/circlemud /var/lib/circlemud/etc
	fowners -R :gamestat /var/lib/circlemud/etc /etc/circlemud

	dodoc doc/{README.UNIX,*.pdf,*.txt} ChangeLog FAQ README release_notes.${PV}.txt
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-3.1-r2" && HAD_BROKEN_PERMISSIONS=1
	HAD_BROKEN_PERMISSIONS=1
}

pkg_postinst() {
	if [[ ${HAD_BROKEN_PERMISSIONS} -eq 1 ]] ; then
		elog "Moving ${EROOT}/var/lib/circlemud/etc/ to ${EROOT}/etc/circlemud"
		elog "Backup stored at ${EROOT}/var/lib/circlemud/etc.bak"

		cp -r "${EROOT}"/var/lib/circlemud/etc/ "${EROOT}"/var/lib/circlemud/etc.bak
		mv -v "${EROOT}"/var/lib/circlemud/etc/* "${EROOT}"/etc/circlemud

		elog "Fixing permissions on ${EROOT}/etc/circlemud"
		chown -vR :gamestat "${EROOT}"/etc/circlemud
		chmod 770 "${EROOT}"/etc/circlemud/
		chmod 660 "${EROOT}"/etc/circlemud/*

		rm -r "${EROOT}"/var/lib/circlemud/etc
		ln -s ../../../etc/circlemud "${EROOT}"/var/lib/circlemud/etc
	fi
}

######################################################################
# Communi
######################################################################

include(../pkg.pri)

pkgExists(uchardet) {
	CONFIG += link_pkgconfig
	PKGCONFIG += uchardet
}

isEmpty(PKGCONFIG) {
	error("UChardet support has been enabled, but the UChardet installation has not been found. Did you emerged app-i18n/uchardet?")
} else {
	LIBS += -luchardet
	INCPATH += -isystem /usr/include/uchardet
}

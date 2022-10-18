
if { [info commands ::IMC::uninstall] eq "::IMC::uninstall" } { ::IMC::uninstall }

namespace eval ::IMC {
	array set OPERLINE {
		"login"				"geofront"
		"password"			"geozzz"
		"flags"				"+cF"
	}
	array set SCRIPT {
		"name"				"IMC"
		"version"			"0.0.1"
		"auteur"			"ZarTek-Creole"
		"DieOnError"		"1"
		"need_mysqltcl"		""
	}
	if { [catch { package require mysqltcl } err] } {
		set MSG_Err	[format \
			"\[%s - erreur\] Nécessite le package %s v%s (ou plus) pour fonctionner, Télécharger sur '%s'.\nLe chargement du script a été annulé."								\
			${SCRIPT(name)}									\
			"mysqltcl"										\
			${SCRIPT(need_mysqltcl)} 						\
			"https://github.com/ZarTek-Creole/TCL-ZCT"		\
			];
		putlog ${MSG_Err};
		if { ${SCRIPT(DieOnError)} == 1 } { die ${MSG_Err} }
	}
}

proc ::IMC::server:init { args } {
	putquick "OPER ${::IMC::OPERLINE(login)} ${::IMC::OPERLINE(password)}"
	putserv "MODE ${::botnick} ${::IMC::OPERLINE(flags)}"
}


proc ::IMC::uninstall {args} {
	putlog [format "Désallocation des ressources de \002%s\002..." ${::IMC::SCRIPT(name)}];
	foreach binding [lsearch -inline -all -regexp [binds *[set ns [string range [namespace current] 2 end]]*] " \{?(::)?${ns}"] {
		unbind [lindex ${binding} 0] [lindex ${binding} 1] [lindex ${binding} 2] [lindex ${binding} 4];
	}
	namespace delete ::IMC
}
bind evnt - init-server ::IMC::server:init
putlog [format "Chargement de Mini-Eva (%s) version %s by %s" ${::IMC::SCRIPT(name)} ${::IMC::SCRIPT(version)} ${::IMC::SCRIPT(auteur)}]
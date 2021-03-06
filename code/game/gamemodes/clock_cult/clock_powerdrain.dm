//horrifying power drain proc made for clockcult's power drain in lieu of six istypes or six for(x in view) loops
/atom/movable/proc/power_drain(clockcult_user)
	return 0

/obj/machinery/power/apc/power_drain(clockcult_user)
	if(cell && cell.charge)
		playsound(src, "sparks", 50, 1)
		flick("apc-spark", src)
		. += min(cell.charge, 500)
		cell.charge = max(0, cell.charge - 500) //Better than a power sink!
		if(!cell.charge && !shorted)
			shorted = 1
			visible_message("<span class='warning'>The [name]'s screen blurs with static.</span>")
		update()
		update_icon()

/obj/machinery/power/smes/power_drain(clockcult_user)
	if(charge)
		. += min(charge, 500)
		charge = max(0, charge - 50000)
		if(!charge && !panel_open)
			panel_open = TRUE
			icon_state = "[initial(icon_state)]-o"
			var/datum/effect_system/spark_spread/spks = new(get_turf(src))
			spks.set_up(10, 0, get_turf(src))
			spks.start()
			visible_message("<span class='warning'>[src]'s panel flies open with a flurry of spark</span>")
		update_icon()

/obj/item/weapon/stock_parts/cell/power_drain(clockcult_user)
	if(charge)
		. += min(charge, 500)
		charge = use(max(0, charge - 500))
		updateicon()

/obj/machinery/light/power_drain(clockcult_user)
	if(on)
		playsound(src, 'sound/effects/light_flicker.ogg', 50, 1)
		flicker(2)
		. += 50
	else if(prob(50))
		burn_out()

/mob/living/silicon/robot/power_drain(clockcult_user)
	if((!clockcult_user || !is_servant_of_ratvar(src)) && cell && cell.charge)
		. += min(cell.charge, 500)
		cell.charge = max(0, cell.charge - 500)
		src << "<span class='userdanger'>ERROR: Power loss detected!</span>"
		spark_system.start()

/obj/mecha/power_drain(clockcult_user)
	if((!clockcult_user || !occupant || occupant && !is_servant_of_ratvar(occupant)) && cell && cell.charge)
		. += min(cell.charge, 500)
		cell.charge = max(0, cell.charge - 500)
		occupant_message("<span class='userdanger'>Power loss detected!</span>")
		spark_system.start()
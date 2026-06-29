import fitz
import os

script_dir = os.path.dirname(os.path.abspath(__file__))

writer = fitz.open()

# Deine PDF-Dateien hier eintragen
dateien = [
         # 0. Titelblatt
          "titelblatt.pdf",

         # 1. Projektauftrag
          "projektauftrag.pdf",  

          # 2. Phasen und Meilensteindiagramm
          "meilsteinenplan.pdf",  

          # 3. Risikobetrachtung                                                                                               
          "risikoanalyse.pdf",                                                                                             
          "risikomatrix.pdf",

          # 4. Projektstrukturplan
          "projektstrukturplan.pdf",  

          # 5. Ablaufplan mit kritischem Pfad
          "ablaufplan.pdf", 

          #6. /                                                                                       
        
          # 7. Projektplanung                                                                                                                                                                                                          
          "lastenheft.pdf",                                                                                    
                                                                                                   
          # 8. Management Status Report                                                                                          
          "management_status_report.pdf",     

          # Sonstiges                                                                                  
          "Mockup.pdf",                                                                                                    
          "ablaufdiagramm_bewertung.pdf",     
          "ressourcen_budget_planung.pdf",                                                                                                                                                                                                                                                
      ]           
for pdf in dateien:
    writer.insert_pdf(fitz.open(os.path.join(script_dir, pdf)))

writer.save(os.path.join(script_dir, "zusammengefuegt.pdf"))
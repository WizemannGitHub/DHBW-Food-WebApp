import fitz
import os

script_dir = os.path.dirname(os.path.abspath(__file__))

writer = fitz.open()

# Deine PDF-Dateien hier eintragen
dateien = [                                                                                                          
         # 1. Projektinitiierung                                                                                          
          "projektauftrag.pdf",                                                                                            
          "lastenheft.pdf",                                                                                                
        
          # 2. Projektplanung                                                                                              
          "projektstrukturplan.pdf",                                                                                                                                                                                  
          "ablaufplan.pdf",                                                                                                
          "meilsteinenplan.pdf",                                                                                           
          "ressourcen_budget_planung.pdf",                                                                                 
                                                                                                                         
          # 3. Risikoanalyse                                                                                               
          "risikoanalyse.pdf",                                                                                             
          "risikomatrix.pdf",                                                                                              
                                                                                                                           
          # 4. Projektumsetzung / Design                                                                                   
          "Mockup.pdf",                                                                                                    
          "ablaufdiagramm_bewertung.pdf",                                                                                                                                                                  
                                                                                                                           
          # 5. Projektcontrolling                                                                                          
          "management_status_report.pdf",                                                                                  
      ]           
for pdf in dateien:
    writer.insert_pdf(fitz.open(os.path.join(script_dir, pdf)))

writer.save(os.path.join(script_dir, "zusammengefuegt.pdf"))